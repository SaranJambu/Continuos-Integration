pipeline {
    agent any

    // Define global variables
    environment {
        REMOTE_HOST = '192.168.10.127'
        REMOTE_USERNAME = 'Infodba'
        REMOTE_PASSWORD = 'Infodba' // Consider using SSH key authentication instead
        SOURCE_FILE = 'Admin_Data//Preferences//Group//Preference.xml' // Adjusted path separator
        DESTINATION_DIR = 'D://WorkingDir//Preferences//Group' // Adjusted path separator
		PREFS_MANAGER_CMD = 'set TC_ROOT=D:\\TC14\\TC_ROOT && set TC_DATA=D:\\TC14\\tcdata && D:\\TC14\\tcdata\\tc_profilevars && preferences_manager -u=infodba -p=infodba -g=dba -mode=import -scope=SITE -file=D:\\WorkingDir\\Preferences\\Group\\Preference.xml -action=OVERRIDE'

    }

    stages {
        stage('Set Variables') {
            steps {
                script {
                    // Print out the global variables
                    echo "Remote Host: ${env.REMOTE_HOST}"
                    echo "Remote Username: ${env.REMOTE_USERNAME}"
                    echo "Source File: ${env.SOURCE_FILE}"
                    echo "Destination Directory: ${env.DESTINATION_DIR}"
                    
                    // Proceed with other steps within this stage
                }
            }
        }
        
        stage('Checkout') {
            steps {
                // Checkout the code from the GitHub repository
                git branch: 'main', credentialsId: 'SaranJambuGIT', url: 'https://github.com/SaranJambu/Continuos-Integration.git'
            }
        }        
        stage('Transfer File to Remote Host') {
            steps {
                script {
                    // Use the global variables
                    def sourcePath = env.SOURCE_FILE // Corrected source file path
                    def destinationPath = "/D:/WorkingDir/Preferences/Group/" // Removed extra backslash
                    def remoteHost = env.REMOTE_HOST
                    def remoteUsername = env.REMOTE_USERNAME
                    
                    // Print out the command for debugging
                    echo "Executing command: scp ${sourcePath} ${remoteUsername}@${remoteHost}:${destinationPath}"
                    
                    // Transfer the file to the remote host
                    bat "scp \"${sourcePath}\" ${remoteUsername}@${remoteHost}:${destinationPath}"
                }
            }
        }
		stage('Run Preferences Manager Utility') {
            steps {
                script {
                    echo 'Running preferences_manager command...'

                    def TC_ROOT = 'D:\\TC14\\TC_ROOT'
                    def TC_DATA = 'D:\\TC14\\tcdata'
                    def PREFS_MANAGER_CMD = """
                        set TC_ROOT=${TC_ROOT} && set TC_DATA=${TC_DATA} && ${TC_DATA}\\tc_profilevars &&
                        "C:\\path\\to\\preferences_manager" -u=infodba -p=infodba -g=dba -mode=import -scope=SITE -file=D:\\WorkingDir\\Preferences\\Group\\Preference.xml -action=OVERRIDE
                    """
                    
                    echo "Command: ${PREFS_MANAGER_CMD}"
    
                    bat label: 'Run preferences_manager', script: PREFS_MANAGER_CMD
                }
            }
    }
}
}