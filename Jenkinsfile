pipeline {
    agent any
    stages {
        stage('Infrastructure') {
            steps {
                dir('terraform') {
                    sh 'terraform init && terraform apply -auto-approve'
                }
            }
        }
        stage('Config & Install') {
            steps {
                dir('ansible') {
                    sh 'ansible-playbook -i inventory.ini playbook.yml'
                }
            }
        }
        stage('Build & Deploy') {
            steps {
                sh 'docker-compose up -d --build'
            }
        }
        stage('Smoke Test') {
            steps {
                sh 'bash test.sh'
            }
        }
    }
}