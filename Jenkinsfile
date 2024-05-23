def remote = [:]
remote.name = 'Infodba'
remote.host = '192.168.10.127'
remote.allowAnyHosts = true
pipeline {
    agent any

    environment {
        REMOTE_HOST = '192.168.10.127'
        REMOTE_USERNAME = 'Infodba'
        SOURCE_FILE = 'Admin_Data//Preferences//Group//Preference.xml' // Retained double slashes
        DESTINATION_DIR = 'D://WorkingDir//Preferences//Group' // Retained double slashes
		REMOTE_USER=credentials('SysUser')
    }

    stages {
        stage('Set Variables') {
            steps {
                script {
                    echo "Remote Host: ${env.REMOTE_HOST}"
                    echo "Remote Username: ${env.REMOTE_USERNAME}"
                    echo "Source File: ${env.SOURCE_FILE}"
                    echo "Destination Directory: ${env.DESTINATION_DIR}"
                }
            }
        }

        stage('Checkout') {
            steps {
                git branch: 'main', credentialsId: 'SaranJambuGIT', url: 'https://github.com/SaranJambu/Continuos-Integration.git'
            }
        }

        stage('Transfer File to Remote Host') {
            steps {
                script {
                    def sourcePath = env.SOURCE_FILE
                    def destinationPath = env.DESTINATION_DIR
                    def remoteHost = env.REMOTE_HOST
                    def remoteUsername = env.REMOTE_USERNAME

                    echo "Executing command: scp ${sourcePath} ${remoteUsername}@${remoteHost}:${destinationPath}"
                    
                    // Transfer the file to the remote host
                    bat "scp ${sourcePath} ${remoteUsername}@${remoteHost}:${destinationPath}"
                }
            }
        }

        stage('Running the command in remote host') {
            steps {
                script {
				remote.user=env.REMOTE_USER_USR
				remote.password=env.REMOTE_USER_PWD
                    
                }
				sshCommand(remote: remote, command: "D:/TC14/TC_ROOT/tc_menu/tc_config1.bat/"
            }
        }
    }
}