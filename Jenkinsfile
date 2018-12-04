#!/usr/bin/env

def image_version = ''
def cli_version = 'v0.5.0'
def compose_version = 'v0.12.4'
def image_name = 'membership\\/dev-induction_app'
def stack_name = 'membership' 

pipeline{
    agent any
    stages{

        stage('checkout code'){
            steps{
                script {
                    echo 'checkout code';
                    checkout scm

                    if (env.BRANCH_NAME != 'master') {
                        image_version = "snapshot-${env.BRANCH_NAME}-${env.BUILD_NUMBER}"
                        image_version = image_version.replace('/','-')
                    }else {
                        image_version = "${env.BUILD_NUMBER}"
                        
                    }
                }
            }
        }

        stage('build docker image and upload'){
            steps{
                echo 'build docker image and upload'
                echo 'version number : ${image_version}'
               script {
                   def image
                   if (env.BRANCH_NAME == 'master') {
                        image = docker.build("dev-induction_app:latest", "--build-arg HTTP_PROXY=http://proxy-internet-aws-china-production.subsidia.org:3128 .")                   
                    } else {
                        image = docker.build("dev-induction_app:latest", "--build-arg HTTP_PROXY=http://proxy-internet-aws-china-production.subsidia.org:3128 .")
                   }

                   docker.withRegistry('https://registry-cn-local.subsidia.org','nexusAccount'){
                       image.push("${image_version}")
                       image.push("latest")
                   }
               }
            }
        }

        stage('clean the docker image'){
            steps {
                sh "docker rmi -f dev-induction_app:latest"
                sh "docker rmi -f registry-cn-local.subsidia.org/dev-induction_app:latest"
                sh "docker rmi -f registry-cn-local.subsidia.org/dev-induction_app:${image_version}"
            }
        }

        stage('Preprare Rancher deployment PP'){
            when { branch 'master' }
            steps{
               echo "downloading cli component"
               sh "wget http://nexus.osiris.withoxylane.com/service/local/repositories/utils/content/rancher/rancher-compose-linux-amd64-${compose_version}.tar.gz -O - | tar -zx"
               sh "wget http://nexus.osiris.withoxylane.com/service/local/repositories/utils/content/rancher/rancher-linux-amd64-${cli_version}.tar.gz -O - | tar -zx"
               sh "mv rancher-compose-${compose_version}/rancher-compose . && rm -rf rancher-compose-${compose_version}"
               sh "mv rancher-${cli_version}/rancher . && rm -rf rancher-${cli_version}"
            }
        }

        stage('Deploy To Rancher PP'){
            when { branch 'master' }
            steps{
                script {
                    try {
                        sh "./rancher --url http://rancher.preprod.subsidia.org --access-key 8F4C8E0E04BA75FC7EFE --secret-key hzKSb6Z9AcoqDbHtWpxkmxVeK9zXPrgaqJdvqo25 export ${stack_name}"
                        sh "mv ${stack_name}/*-compose.yml ."
                    } catch (Exception err){
                        echo "Stack not found"
                    }
                    sh "sed -i \"s/${image_name}:.*\$/${image_name}:${image_version}/g\" docker-compose.yml"
                    sh "sed -i '/dev-induction_app:/a \\ \\ \\ \\ upgrade_strategy:\\n\\r\\ \\ \\ \\ \\ \\ start_first: true' rancher-compose.yml"
                    sh "./rancher-compose --project-name ${stack_name} --url http://rancher.preprod.subsidia.org --access-key 8F4C8E0E04BA75FC7EFE --secret-key hzKSb6Z9AcoqDbHtWpxkmxVeK9zXPrgaqJdvqo25 --verbose up -d --force-upgrade --pull --confirm-upgrade dev-induction_app"
                }
            }

        }

        stage('Clean up workspace'){
            steps {
                cleanWs()
            }
        }
    }
}


