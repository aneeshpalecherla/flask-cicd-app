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
        
        stage('Get Terraform Output') {
            steps {
                dir('terraform') {
                    script {
                        def ip = bat(script: 'terraform output -raw public_ip', returnStdout: true).trim()
                        env.EC2_IP = ip
                        echo "Got EC2 public IP: ${env.EC2_IP}"
                    }
                }
            }
        }

        stage('Deploy Flask App via Docker') {
            steps {
                bat "ssh -i C:\\Users\\Aneesh\\flask-cicd-app\\terraform\\sunny69.pem -o StrictHostKeyChecking=no ec2-user@${env.EC2_IP} \"rm -rf /home/ec2-user/app/*\""
                bat "scp -i C:\\Users\\Aneesh\\flask-cicd-app\\terraform\\sunny69.pem -o StrictHostKeyChecking=no -r . ec2-user@${env.EC2_IP}:/home/ec2-user/app"
                ba
