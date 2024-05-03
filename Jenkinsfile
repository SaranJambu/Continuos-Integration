pipeline {
    agent any

    stages {
        stage('Set Variables') {
            steps {
                script {
                    // Define variables inside the stage
                    def remoteHost = '192.168.10.112'
                    def remoteUsername = 'Infodba'
                    def remotePassword = 'Infodba' // Consider using SSH key authentication instead
                    def sourceFile = 'preference_files//file.txt' // Adjusted path separator
                    def destinationDir = 'C://GIT CLONE' // Adjusted path separator
                    
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
                    def sourceFile = 'preference_files/file.txt' // Adjusted path separator
                    def destinationDir = 'C:/GIT CLONE' // Adjusted path separator
                    
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
                    def sourcePath = "C:/GIT CLONE/file.txt" // Adjusted path separator
                    def destinationPath = "/D:/GIT_CLONE/" // Removed extra backslash
                    def remoteHost = "192.168.10.112"
                    def remoteUsername = "Infodba"
                    // Print out the command for debugging
                    echo "Executing command: scp ${sourcePath} ${remoteUsername}@${remoteHost}:${destinationPath}"
                    
                    // Transfer the file to the remote host
                    bat "scp \"${sourcePath}\" ${remoteUsername}@${remoteHost}:${destinationPath}"
                }
            }
        }
    }
}
