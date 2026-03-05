pipeline {
    agent any
    
    tools {
        // Ensure these names match 'Global Tool Configuration' exactly
        jdk 'java-11'
        maven 'maven'
    }

    environment {
        AWS_ACCOUNT_ID = "045973518289"
        // Use credentials ID from Jenkins instead of env.AWS_CRED
        AWS_REGION     = "us-east-1"
        ECR_REPO       = "045973518289.dkr.ecr.us-east-1.amazonaws.com/guna/app"
        // It's cleaner to use the built-in env.BUILD_NUMBER directly in steps
    }

    stages {
        stage('Git checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Sandesh2080/test-1.git'
            }
        }       

        stage('Build & Install') {
            steps {
                // Running 'install' implies 'compile', so you can save time here
                // Added -DskipTests since you did that in your manual mvn runs
                sh "mvn clean install -DskipTests"
            }
        }

        stage('Building-DockerImage') {
            steps {
                // Fixed: Use a consistent local tag that matches the Push stage
                sh "podman build -t guna_app:${env.BUILD_NUMBER} ."
            }
        }

        stage('Push to ECR') {
            steps {
                script {
                    // 'credentials' refers to the ID in Jenkins Credentials Store
                    withAWS(credentials: 'AWS_CRED', region: "${AWS_REGION}") {
                        sh '''
                            #!/bin/bash
                            set -eux

                            echo "===== Logging into ECR ====="
                            aws ecr get-login-password --region ${AWS_REGION} | \
                            podman login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com

                            echo "===== Tagging Image ====="
                            # Fixed: This now matches the local tag from the previous stage
                            podman tag guna_app:${BUILD_NUMBER} ${ECR_REPO}:${BUILD_NUMBER}
                            podman tag guna_app:${BUILD_NUMBER} ${ECR_REPO}:latest

                            echo "===== Pushing Image ====="
                            podman push ${ECR_REPO}:${BUILD_NUMBER}
                            podman push ${ECR_REPO}:latest

                            echo "===== DONE ====="
                        '''
                    }
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
        success {
            echo "Successfully pushed build ${env.BUILD_NUMBER} to ECR"
        }
    }
}
