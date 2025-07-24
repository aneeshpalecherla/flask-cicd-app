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
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir('terraform') {
                    sh 'terraform plan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('terraform') {
                    sh 'terraform apply -auto-approve'
                }
            }
        }

        stage('Deploy Flask App via Docker') {
            steps {
                sh 'scp -i sunny69.pem -o StrictHostKeyChecking=no -r * ec2-user@<EC2_PUBLIC_IP>:/home/ec2-user/app'
                sh 'ssh -i sunny69.pem -o StrictHostKeyChecking=no ec2-user@<EC2_PUBLIC_IP> "cd app && docker build -t flask-app . && docker run -d -p 5000:5000 flask-app"'
            }
        }
    }
}
