pipeline {
    agent any

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
                    // Define the source file and destination directory
                    def sourceFile = 'preference_files/file.txt'
                    def destinationDir = 'D:\\GIT CLONE'

                    // Copy the file using 'sh' command
                    sh "cp ${sourceFile} ${destinationDir}"
                }
            }
        }
    }
}
