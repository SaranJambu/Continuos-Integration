pipeline {
    agent any

    // Define variables at the top
    def remoteHost = '192.168.10.112'
    def remoteUsername = 'Infodba'
    def remotePassword = 'Infodba'
    def sourceFile = 'preference_files\\file.txt'
    def destinationDir = 'C:\\GIT CLONE'

    stages {
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
                    // Copy the file using 'bat' command
                    bat "xcopy /Y ${sourceFile} \"${destinationDir}\""
                }
            }
        }
        stage('Set Environment Variables') {
            steps {
                script {
                    // Set environment variables
                    withEnv(['TC_ROOT=C:\\Siemens\\Teamcenter14\\TR', 'TC_DATA=C:\\Siemens\\Teamcenter14\\TD']) {
                        // Execute tc_profilevars script
                        bat 'C:\\Siemens\\Teamcenter14\\TD\\tc_profilevars'
                    }
                }
            }
        }
        stage('Transfer File to Remote Host') {
            steps {
                // Use SSH or any other method to transfer the file to the remote host
                // Example:
                bat "scp ${sourceFile} ${remoteUsername}@${remoteHost}:${destinationDir}"
            }
        }
    }
}
