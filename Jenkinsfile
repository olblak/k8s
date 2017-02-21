pipeline {
    agent any

    environment {
        VAULT_PASSWORD = credentials('k8s-vault-password')
    }

    stages {
       stage('Init') {
            steps {
                echo "Checkout Repository"
                checkout scm
                echo "Environment: ${env.ENV}"
                sshagent(['ssh-k8s']) {
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
