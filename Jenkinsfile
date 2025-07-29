pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID       = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
        // Define public_ip here to be set after Terraform Apply
        public_ip = ''
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
                    // Capture the public IP after apply
                    script {
                        env.public_ip = bat(returnStdout: true, script: 'terraform output -raw public_ip').trim()
                        echo "EC2 Instance Public IP: ${env.public_ip}"
                    }
                }
            }
        }

        stage('Deploy Flask App via Docker') {
            steps {
                // Use the correct path to your pem file within the Jenkins workspace
                // and use the dynamic public_ip
                bat "scp -i \"${workspace}\\terraform\\sunny69.pem\" -o StrictHostKeyChecking=no -r * ec2-user@${env.public_ip}:/home/ec2-user/app"
                bat "ssh -i \"${workspace}\\terraform\\sunny69.pem\" -o StrictHostKeyChecking=no ec2-user@${env.public_ip} \"cd app && docker build -t flask-app . && docker run -d -p 5000:5000 flask-app\""
            }
        }
    }
}