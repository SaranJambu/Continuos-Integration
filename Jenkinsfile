pipeline {
    agent any
    environment {
        REMOTE_HOST = '192.168.10.127'
        REMOTE_USERNAME = 'Infodba'
        SOURCE_FILE = 'Admin_Data//Preferences//Group//Preference.xml' // Retained double slashes
        SOURCE_CODE = 'CppCode//ITK.cpp'
        DESTINATION_DIR = 'D://WorkingDir//Preferences//Group' // Retained double slashes
        DESTINATION_DIR_CODE = 'D://CppCode//ITK'
        REMOTE_USER = credentials('SysUser')
    }
    stages {
        stage('Set Variables') {
            steps {
                script {
                    echo "Remote Host: ${env.REMOTE_HOST}"
                    echo "Remote Username: ${env.REMOTE_USERNAME}"
                    echo "Source File: ${env.SOURCE_FILE}"
                    echo "Source code: ${env.SOURCE_CODE}"
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
        stage('Transfer file to Remote Host and Code check Executing') {
            steps {
                script {
                    def sourcePath = env.SOURCE_CODE
                    def destinationPath = env.DESTINATION_DIR_CODE
                    def remoteHost = env.REMOTE_HOST
                    def remoteUsername = env.REMOTE_USERNAME
                    echo "Executing command: scp ${sourcePath} ${remoteUsername}@${remoteHost}:${destinationPath}"
                    
                    // Transfer the file to the remote host
                    bat "scp ${sourcePath} ${remoteUsername}@${remoteHost}:${destinationPath}"
                }
            }
		}
		
		stage('Transfer file to Remote Host and Code check Executing') {
            steps {
                script {
                    def sourcePath = env.SOURCE_CODE
                    def destinationPath = env.DESTINATION_DIR_CODE
                    def remoteHost = env.REMOTE_HOST
                    def remoteUsername = env.REMOTE_USERNAME
                    echo "Executing command: ssh ${remoteUsername}@${remoteHost} 'cppcheck --enable=all \"${destinationPath}\"'"
                    
                    // Transfer the file to the remote host
                    sshagent(['sshCredentaialInfodba']) {
                        sh "ssh ${remoteUsername}@${remoteHost} 'cppcheck --enable=all ${destinationPath}'"
                    }
                }
            }
        }
	}
}
