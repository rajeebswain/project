pipeline{
    agent any

    environment{
        DOCKERHUB_USERNAME = "rajeebswain"
        APP_NAME = "project"
        IMAGE_TAG = "${BUILD_NUMBER}"
        IMAGE_NAME = "${DOCKERHUB_USERNAME}" + "/" + "${APP_NAME}"
        REGISTRY_CREDS = 'dockerhub'
    }

    stages{
        stage('CLean Workspace'){
            steps{
                script{
                    cleanWs()
                }
            }
        }
        stage('Checkout SCM'){
            steps{
                script{
                    git branch: 'main', credentialsId: 'github', url: 'https://github.com/rajeebswain/project.git'
                }
            }
        }
        stage('Build Docker Image'){
            steps{
                script{
                    
                    docker_image = docker.build "${IMAGE_NAME}"
                }
            }
        }
        stage('Push Docker Image'){
            steps{
                script{

                    docker.withRegistry('',REGISTRY_CREDS){
                        docker_image.push("${BUILD_NUMBER}")
                        docker_image.push("latest")
                    }
                }
            }
        }
        stage('Delete Docker Images'){
            steps{
                script{
                    sh "docker rmi ${IMAGE_NAME}:${IMAGE_TAG}"
                    sh "docker rmi ${IMAGE_NAME}:latest"
                }
            }
        }
        stage('Updating Kubernetes Deployment file'){
            steps{
                script{
                    sh """
                    cat deployment.yml
                    sed -i 's/${APP_NAME}.*/${APP_NAME}:${IMAGE_TAG}/g' deployment.yml
                    cat deployment.yml
                    """

                }
            }
        }
        stage('Push the changed deployment file to Git'){
            steps{
                script{
                    sh """
                      git config --global user.name "rajeebswain"
                      git config --global user.email "rajeeb.mop@gmail.com"
                      git add deployment.yml
                      git commit -m "update the deployment file"
                    """
                    withCredentials([gitUsernamePassword(credentialsId: 'github', gitToolName: 'Default')]) {
                      sh "git push 'https://github.com/rajeebswain/project.git' main"
                    }       
                }
            }
        }
    }
}