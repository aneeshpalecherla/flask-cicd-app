pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/aneeshpalecherla/flask-cicd-app.git'
            }
        }

        stage('Terraform Init') {
            steps {
                dir('terraform') {
                    bat 'terraform init'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir('terraform') {
                    bat 'terraform plan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('terraform') {
                    bat 'terraform apply -auto-approve'
                }
            }
        }

        stage('Deploy Flask App via Docker') {
            steps {
                // Use full path to your pem file here
                bat 'scp -i C:\\path\\to\\sunny69.pem -o StrictHostKeyChecking=no -r * ec2-user@54.165.140.189:/home/ec2-user/app'
                bat 'ssh -i C:\\path\\to\\sunny69.pem -o StrictHostKeyChecking=no ec2-user@54.165.140.189 "cd app && docker build -t flask-app . && docker run -d -p 5000:5000 flask-app"'
            }
        }
    }
}

