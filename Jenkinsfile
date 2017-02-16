pipeline {
    agent any

    environment {
        ENV = "dev"
        LOCATION = "eastus"
        PREFIX = "overnin"
        VAULT_PASSWORD = credentials('vault_password')
    }

    stages {
       stage('Init') {
            steps {
                echo "Checkout Repository"
                checkout scm
                echo "Environment: ${env.ENV}"
                sshagent(['jenkins_kubernetes_key']) {
                    sh 'echo SSH_AUTH_SOCK=$SSH_AUTH_SOCK'
                    sh 'ls -al $SSH_AUTH_SOCK || true'
                    sh 'make init'
                }
            }
        }

       stage('Deploy') {
            steps {
                echo 'Apply Kubernetes Resources'
                sh 'make apply'
            }
        }

    }
    post {
        always {
            echo 'prune and cleanup'
            sh 'make clean'
        }
    }
}
