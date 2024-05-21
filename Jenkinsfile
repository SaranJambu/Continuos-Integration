pipeline {
    agent any

    // Define global variables
    environment {
        REMOTE_HOST = '192.168.10.127'
        REMOTE_USERNAME = 'Infodba'
        REMOTE_PASSWORD = 'Infodba' // Consider using SSH key authentication instead
        DESTINATION_DIR = '/D:/GIT_CLONE' // Adjusted path separator
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout the code from the GitHub repository
                git branch: 'main', credentialsId: 'SaranJambuGIT', url: 'https://github.com/SaranJambu/Continuos-Integration.git'
            }
        }

        stage('Determine Changed Files') {
            steps {
                script {
                    // Get the list of files changed in the last commit
                    def changedFiles = sh(script: "git diff --name-only HEAD HEAD~1", returnStdout: true).trim()
                    echo "Changed files:\n${changedFiles}"
                    env.CHANGED_FILES = changedFiles
                }
            }
        }

        stage('Transfer Changed Files to Remote Host') {
            steps {
                script {
                    // Split the changed files into an array
                    def files = env.CHANGED_FILES.split("\n")
                    for (file in files) {
                        // Use the global variables for paths
                        def sourcePath = file
                        def destinationPath = "${env.DESTINATION_DIR}/${file}".replaceAll('\\\\', '/')
                        def remoteHost = env.REMOTE_HOST
                        def remoteUsername = env.REMOTE_USERNAME
                        
                        // Create remote directory if necessary
                        def remoteDir = destinationPath.substring(0, destinationPath.lastIndexOf("/"))
                        bat "ssh ${remoteUsername}@${remoteHost} \"mkdir -p ${remoteDir}\""
                        
                        // Print out the command for debugging
                        echo "Executing command: scp \"${sourcePath}\" ${remoteUsername}@${remoteHost}:${destinationPath}"
                        
                        // Transfer the file to the remote host
                        bat "scp \"${sourcePath}\" ${remoteUsername}@${remoteHost}:${destinationPath}"
                    }
                }
            }
        }
    }
}
