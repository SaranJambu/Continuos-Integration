@echo on
::setting env Variable Start
setlocal enabledelayedexpansion

::setting env Variable END


echo === Packaging template START ===
echo.
call %TC_ROOT%\bin\bmide_generate_package.bat -projectLocation=%ACTC_CUSTOM_CONFIG_DIR_LOCAL%\%PROJECT_TEMPLATE_NAME% -packageLocation=%ACTC_CUSTOM_CONFIG_DIR% -dependencyTemplateFolder=%TC_DATA%\model -softwareVersion=%softwareVersion% || exit /b !ERRORLEVEL!
echo === Packaging template END ===

::searching for the recently created folder
pushd %ACTC_CUSTOM_CONFIG_DIR%
for /f "delims=" %%i IN ('dir /b /ad /t:c /od') DO (
    echo "Setting PACKFOLDER to %%i"
    SET PACKFOLDER=%%i
)
popd
echo Final PACKFOLDER: %PACKFOLDER%
echo.
echo === [ Copy template files START ] === 
for /f %%A IN ('wmic os get LocalDateTime ^| findstr \.') do set B=%%A 
set TS=%B:~2,12% 
set BMIDE_PKG=%TEMP%\mi8_deploy_data_model_%TS%

mkdir "%BMIDE_PKG%" || exit /b !ERRORLEVEL!
echo n | "%TC_ROOT%\install\install\7za" x -aoa -bb2 -bd -o"%BMIDE_PKG%" "%ACTC_CUSTOM_CONFIG_DIR%\%PACKFOLDER%\artifacts\%PROJECT_TEMPLATE_NAME%_template.zip"


xcopy "%BMIDE_PKG%\install\%PROJECT_TEMPLATE_NAME%\%PROJECT_TEMPLATE_NAME%_template.xml" "%TC_DATA%\model\" /i /r /y /f || exit /b !ERRORLEVEL!
xcopy "%BMIDE_PKG%\install\%PROJECT_TEMPLATE_NAME%\%PROJECT_TEMPLATE_NAME%_dependency.xml" "%TC_DATA%\model\" /i /r /y /f || exit /b !ERRORLEVEL!
xcopy "%BMIDE_PKG%\install\%PROJECT_TEMPLATE_NAME%\lang\%PROJECT_TEMPLATE_NAME%_template_en_US.xml" "%TC_DATA%\model\lang\" /i /r /y /f || exit /b !ERRORLEVEL!
xcopy "%ACTC_CUSTOM_CONFIG_DIR%\%PACKFOLDER%\artifacts\client_%PROJECT_TEMPLATE_NAME%.properties" "%TC_DATA%\model\" /i /r /y /f || exit /b !ERRORLEVEL!
xcopy "%ACTC_CUSTOM_CONFIG_DIR%\%PACKFOLDER%\artifacts\%PROJECT_TEMPLATE_NAME%_icons.zip" "%TC_DATA%\model\icons\" /i /r /y /f || exit /b !ERRORLEVEL!

del /f /q "%BMIDE_PKG%"
echo === [ Copy template files END ] === 
echo.
echo === [ Extract data model START ] ===
call "%TC_BIN%\business_model_extractor" -u=%ACTC_DATA_LOAD_USER% -p=%ACTC_DATA_LOAD_USER_PWD% -g=%ACTC_DATA_LOAD_USER_GRP% -outfile="%TC_DATA%\model\model.xml" || exit /b !ERRORLEVEL!
echo === [ Extract data model END ] ===
echo.
echo === [ Generate delta changes START ] === 
call "%TC_BIN%\bmide_processtemplates" -u=%ACTC_DATA_LOAD_USER% -p=%ACTC_DATA_LOAD_USER_PWD% -g=%ACTC_DATA_LOAD_USER_GRP% -mode=server -dir="%TC_DATA%\model" -templates="%PROJECT_TEMPLATE_NAME%" -deployvalidation=yes || exit /b !ERRORLEVEL!
echo === [ Generate delta changes END ] === 

echo === [ Pre-deploy START ] ===
echo.
call "%TC_BIN%\install" -regen_schema_file -u=%ACTC_DATA_LOAD_USER% -p=%ACTC_DATA_LOAD_USER_PWD% -g=%ACTC_DATA_LOAD_USER_GRP% || exit /b !ERRORLEVEL!
call "%TC_BIN%\install" -lock_db -u=%ACTC_DATA_LOAD_USER% -p=%ACTC_DATA_LOAD_USER_PWD% -g=%ACTC_DATA_LOAD_USER_GRP% || exit /B !ERRORLEVEL!
call "%TC_BIN%\clearlocks" -assert_all_dead -u=%ACTC_DATA_LOAD_USER% -p=%ACTC_DATA_LOAD_USER_PWD% -g=%ACTC_DATA_LOAD_USER_GRP% || exit /b !ERRORLEVEL!
echo.
echo === [ Pre-deploy END ] ===

echo.
echo === [ Update data model START ] ===
echo.
call "%TC_BIN%\business_model_updater.exe" -u=%ACTC_DATA_LOAD_USER% -p=%ACTC_DATA_LOAD_USER_PWD% -g=%ACTC_DATA_LOAD_USER_GRP% -mode=upgrade -update=all -process=all -file="%TC_DATA%\model\delta.xml" -predelta -nolocalization || exit /b !ERRORLEVEL!
echo === [ Update data model END ] ===

echo === [ Update data model lang START ] ===
echo.
call "%TC_BIN%\business_model_updater.exe" -u=%ACTC_DATA_LOAD_USER% -p=%ACTC_DATA_LOAD_USER_PWD% -g=%ACTC_DATA_LOAD_USER_GRP% -mode=upgrade -update=localization -process=all -file="%TC_DATA%\model\lang\delta_lang.xml" || exit /b !ERRORLEVEL!
echo === [ Update data model lang END ] ===
echo.
echo === [ Post-deploy START ] ===
echo.
call "%TC_BIN%\install" -regen_schema_file -u=%ACTC_DATA_LOAD_USER% -p=%ACTC_DATA_LOAD_USER_PWD% -g=%ACTC_DATA_LOAD_USER_GRP% || exit /b !ERRORLEVEL!
call "%TC_BIN%\install" -gen_xmit_file -u=%ACTC_DATA_LOAD_USER% -p=%ACTC_DATA_LOAD_USER_PWD% -g=%ACTC_DATA_LOAD_USER_GRP% || exit /b !ERRORLEVEL!
call "%TC_BIN%\bmide_manage_templates" -u=%ACTC_DATA_LOAD_USER% -p=%ACTC_DATA_LOAD_USER_PWD% -g=%ACTC_DATA_LOAD_USER_GRP% -option=fullupdate -templates="%PROJECT_TEMPLATE_NAME%" || exit /b !ERRORLEVEL!
call "%TC_BIN%\clearlocks" -assert_all_dead -u=%ACTC_DATA_LOAD_USER% -p=%ACTC_DATA_LOAD_USER_PWD% -g=%ACTC_DATA_LOAD_USER_GRP% || exit /b !ERRORLEVEL!
call "%TC_BIN%\install" -unlock_db -u=%ACTC_DATA_LOAD_USER% -p=%ACTC_DATA_LOAD_USER_PWD% -g=%ACTC_DATA_LOAD_USER_GRP% || exit /B !ERRORLEVEL!
echo === [ Post-deploy END ] ===
echo.
echo ==[ Generate TCPLMML schema START ]==
call "%TC_BIN%\bmide_generatetcplmxmlschema.bat" -u=%ACTC_DATA_LOAD_USER% -p=%ACTC_DATA_LOAD_USER_PWD% -g=%ACTC_DATA_LOAD_USER_GRP% || exit /b !ERRORLEVEL!
echo ==[ Generate TCPLMML schema END ]==
echo.
echo ==[ Setup knowledgebase START ]==
call "%TC_BIN%\bmide_setupknowledgebase.bat" -u=%ACTC_DATA_LOAD_USER% -p=%ACTC_DATA_LOAD_USER_PWD% -g=%ACTC_DATA_LOAD_USER_GRP% -regen=false || exit /b !ERRORLEVEL!
echo ==[ Setup knowledgebase END ]==
echo.
echo ==[ Model tool START ]==
call "%TC_BIN%\bmide_modeltool.bat" -u=%ACTC_DATA_LOAD_USER% -p=%ACTC_DATA_LOAD_USER_PWD% -g=%ACTC_DATA_LOAD_USER_GRP% -tool=all -mode=update -target_dir="%TC_DATA%" -model_file="%TC_DATA%"\model\model.xml || exit /b !ERRORLEVEL!
echo ==[ Model tool END ]==
echo ==[ TcSchema To SolrSchema Transform START ]==
call "%TC_SOLR_ROOT%\TcSchemaToSolrSchemaTransform.bat" "%TC_DATA%\ftsi\solr_schema_files" || exit /b !ERRORLEVEL!
echo ==[ TcSchema To SolrSchema Transform END ]==

