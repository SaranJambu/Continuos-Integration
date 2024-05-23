pipeline {
    agent any

    environment {
        REMOTE_HOST = '192.168.10.127'
        REMOTE_USERNAME = 'Infodba'
        SOURCE_FILE = 'Admin_Data//Preferences//Group//Preference.xml' // Retained double slashes
        DESTINATION_DIR = 'D://WorkingDir//Preferences//Group' // Retained double slashes
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

        stage('Set Environment Variables and Run Commands') {
            steps {
                script {
                    // Combine all commands into one SSH command
                    def remoteCommand = '''
                        SET TC_ROOT=D:\\TC14\\TC_ROOT &&
                        SET TC_DATA=D:\\TC14\\tcdata &&
                        D:\\TC14\\tcdata\\tc_profilevars &&
                        preferences_manager -u=infodba -p=infodba -g=dba -mode=import -scope=SITE -file=D:\\WorkingDir\\Preferences\\Group\\Preference.xml -action=OVERRIDE
                    '''
                    
                    // Properly format the SSH command for Windows
                    def sshCommand = "ssh -T ${REMOTE_USERNAME}@${REMOTE_HOST} \"${remoteCommand}\""
                    
                    // Print out the SSH command for debugging
                    echo "Executing SSH command: ${sshCommand}"
                    
                    // Execute the combined command on the remote host
                    bat sshCommand
                }
            }
        }
    }
}
