pipeline{
	agent any

	tools {
		jdk 'java-11'
		maven 'maven'
	}
	    environment {
        AWS_ACCOUNT_ID = "045973518289"
        AWS_CRED = "${env.AWS_CRED}"
        AWS_REGION     = "${env.AWS_REGION ?: 'us-east-1'}"
        IMAGE_NAME     = "dev/microsvc"
        ECR_REPO       = "045973518289.dkr.ecr.us-east-1.amazonaws.com/guna/app"
		BUILD_NUMBER = "${env.BUILD_NUMBER}"
    }

	stages{
		stage('Git checkout'){
			steps{
				git branch: 'main', url: 'https://github.com/Sandesh2080/test-1.git'
			}
		}		
		stage('Build'){
			steps{
				sh 'mvn clean package'
			}
		}
		stage('Building-DockerImage'){
			steps{
				sh 'podman build -t Guna_app/continous-intergartion:1 .'
			}
		}

	    stage('Push to ECR') {
            steps {
                script {
                    withAWS(credentials: 'AWS_CRED', region: "${AWS_REGION}") {
                        sh '''
                            #!/bin/bash
                            set -eux

                            echo "===== AWS CLI Version ====="
                            aws --version

                            echo "===== Logging into ECR ====="
                            aws ecr get-login-password \
                                | podman login \
                                    --username AWS \
                                    --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com

                            echo "===== Tagging Image ====="
                            podman tag guna_app:"${BUILD_NUMBER}" \
                                ${ECR_REPO}:"${BUILD_NUMBER}"

                            echo "===== Pushing Image ====="
                            podman push \
                                ${ECR_REPO}:"${BUILD_NUMBER}"

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
            echo "Image pushed to ECR: ${ECR_REPO}:latest"
        }
    }
}
