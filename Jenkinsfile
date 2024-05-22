pipeline {
    agent any
    environment {
        REMOTE_SERVER = '13.200.249.27'
        REMOTE_USER = 'ubuntu'
       
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/krishnakumarayeenduguli/devops-automation.git'
            }
        }
        stage('Maven Build') {
            steps {
                sh 'mvn clean install'
            }
            post {
                success {
                    archiveArtifacts artifacts: '**/target/*.jar'
                }
            }
        }
        stage('Maven Test') {
            steps {
                sh 'mvn test'
            }
        }
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t devops-automation:latest .'
                sh 'docker tag devops-automation krishnakumarayeenduguli/devops-automation:latest'
            }
        }
        stage('Login to DockerHub') {
            steps {
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
            }
        }
        stage('Push Image to DockerHub') {
            steps {
                sh 'docker push krishnakumarayeenduguli/devops-automation:latest'
            }
            post {
                always {
                    sh 'docker logout'
                }
            }
        }
        stage('Deploy Docker Image to AWS Instance') {
            steps {
                script {
                    sshagent(credentials: ['awscred']) {
                        sh "ssh -o StrictHostKeyChecking=no ${REMOTE_USER}@${REMOTE_SERVER} 'docker stop javaApp || true && docker rm javaApp || true'"
                        sh "ssh -o StrictHostKeyChecking=no ${REMOTE_USER}@${REMOTE_SERVER} 'docker pull krishnakumarayeenduguli/devops-automation:latest'"
                        sh "ssh -o StrictHostKeyChecking=no ${REMOTE_USER}@${REMOTE_SERVER} 'docker run --name javaApp -d -p 8081:8081 krishnakumarayeenduguli/devops-automation:latest'"
                    }
                }
            }
        }
    }
}
