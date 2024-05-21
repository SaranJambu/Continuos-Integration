pipeline {
    agent any

    // Define global variables
    environment {
        REMOTE_HOST = '192.168.10.127'
        REMOTE_USERNAME = 'Infodba'
        REMOTE_PASSWORD = 'Infodba' // Consider using SSH key authentication instead
        SOURCE_FILE = 'Admin_Data//Preferences//Group//Preference.xml' // Adjusted path separator
        DESTINATION_DIR = 'D://WorkingDir//Preferences//Group' // Adjusted path separator
        
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
    }
}