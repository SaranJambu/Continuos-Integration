pipeline {
    agent any

    stages {
        stage('Set Variables') {
            steps {
                script {
                    // Define variables inside the stage
                    def remoteHost = '192.168.10.112'
                    def remoteUsername = 'Infodba'
                    def remotePassword = 'Infodba'
                    def sourceFile = 'preference_files\\file.txt'
                    def destinationDir = 'C:\\GIT CLONE'
                    
                    // Use the variables within the same stage
                    echo "Remote Host: ${remoteHost}"
                    echo "Remote Username: ${remoteUsername}"
                    echo "Source File: ${sourceFile}"
                    echo "Destination Directory: ${destinationDir}"
                    
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
        
        stage('Copy File') {
            steps {
                // Copy the specific file from the checked out repository
                script {
                    // Use the variables defined in the previous stage
                    def sourceFile = 'preference_files\\file.txt'
                    def destinationDir = 'C:\\GIT CLONE'
                    
                    // Copy the file using 'bat' command
                    bat "xcopy /Y \"${sourceFile}\" \"${destinationDir}\""
                }
            }
        }        
        stage('Transfer File to Remote Host') {
            steps {
                // Use the variables defined in the 'Set Variables' stage
                script {
                    // Define the source and destination paths using the variables
                    def sourcePath = "C:\\GIT CLONE\\file.txt"
                    def destinationPath = "\\D:\\GIT_CLONE\\"
                    def remoteUsername = "Infodba"
                    def remoteHost = "192.168.10.112"
                    // Print out the command for debugging
                    echo "Executing command: scp ${sourcePath} ${remoteUsername}@${remoteHost}:${destinationPath}"
                    echo "scp "${sourcePath}" ${remoteUsername}@${remoteHost}:/${destinationPath}"
                    // Transfer the file to the remote host
                    sh "scp \"${sourcePath}\" ${remoteUsername}@${remoteHost}:${destinationPath}"
                    
                }
            }
        }
    }
}
