import xml.etree.ElementTree as ET
import subprocess
import sys

# Read the config file
def read_config(Config_list):
    config = {}
    with open(Config_list, "r") as file:
        for line in file:
            # Ignore empty lines and comments (if any)
            if "=" in line and not line.startswith("#"):
                key, value = line.strip().split("=", 1)  # Split at the first '='
                config[key] = value  # Store in dictionary
    return config


# Prepare Arguments for quick deploy utility

def bat_args(required_keys):
    config=read_config(Config_list)
    config_dict={}
    for i in required_keys: 
        val=config.get(i)
        config_dict[i]=val
    # print("config_dict:",config_dict)
    args = [f"-{key}={value}" for key, value in config_dict.items()]
    print("args =",args)
    return args
    

def update_version(version_value,target_xml):
# Modify Deployment center input xml
    print("version value is -",version_value)
    print("Import Xml -",target_xml)
    target_tree = ET.parse(target_xml)
    target_root = target_tree.getroot()
    project_name=config.get("ProjectName")
    # print("Project Name=",project_name)
    for software in target_root.findall(".//software"):
        if software.get("id") == project_name:
            software.set("version", version_value)
    version_element = root.find("version") 
    target_tree.write(target_xml, encoding="utf-8", xml_declaration=True)
    return True

if __name__=="__main__":
    Config_list="C:\Devops_Scripts\Config.txt"
    required_keys = {"environment", "inputFile", "dcusername", "dcpassword", "dcUrl", "scriptDirectoryName"}
    config=read_config(Config_list)
    Bmide_input=config.get("BmidePackageVersion")
    print("BmidePackageVersion-",Bmide_input)
    tree = ET.parse(Bmide_input)
    root = tree.getroot()
    # Find the <version> tag and get its text
    version_element = root.find("version") 
    if version_element is not None:
        version_value = version_element.text
        print("Version:", version_value)
        config=read_config(Config_list)
        target_xml=config.get("InputXml")
        update_version(version_value,target_xml)
    else:
        print("Version tag not found!")

    # Genrate new scripts for BMIDE
    bat_file =config.get("QD_Bat")
    print("bat file location",bat_file)

    # Run the batch file with arguments
    bat_args_LIST=bat_args(required_keys)
    result = subprocess.run([bat_file] + bat_args_LIST, capture_output=True, text=True, shell=True)
    # print("Output:", result.stdout)
    # print("Errors:", result.stderr)

    # print("Output:", result.stdout)

    if result.returncode != 0:
        print("ERROR: Batch file failed")
        print("Errors:", result.stderr)
        sys.exit(result.returncode)  # Pass the batch file's exit code to Jenkins

    print("SUCCESS: Batch file completed")
    sys.exit(0)

    # try:
    #     # Your logic here
    #     print("SUCCESS")
    #     result.exit(0)  # Exit with success
    # except Exception as e:
    #     print(f"ERROR: {str(e)}")
    #     result.exit(1)
