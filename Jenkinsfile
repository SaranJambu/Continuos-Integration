pipeline {
    agent any
    
    def remoteHost = '192.168.1.100'
    def remoteUsername = 'Infodba'
    def remotePassword = 'Infodba'
    def sourceFile = 'preference_files\\file.txt'
    def destinationDir = 'C:\\GIT CLONE'

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', credentialsId: 'SaranJambuGIT', url: 'https://github.com/SaranJambu/Continuos-Integration.git'
            }
        }
        stage('Copy File') {
            steps {
                script {
                    // Transfer the file to the remote system
                    bat "scp ${sourceFile} ${remoteUsername}@${remoteHost}:${destinationDir}"
                }
            }
        }
        stage('Run Command on Remote System') {
            steps {
                script {
                    // Connect to the remote system and run a command
                    bat "ssh ${remoteUsername}@${remoteHost} cmd /c \"echo ${destinationDir}\\file.txt\""
                }
            }
        }
    }
}
