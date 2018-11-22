#!/usr/bin/env

pipeline{
    agent any

    stages{

        stage('checkout code'){
            steps{
                echo 'checkout code';
                checkout scm
            }
        }
        stage('Send to rancher agent'){
            steps {
                withEnv(["BUILD_NUMBER=${env.BUILD_NUMBER}"]){
                    sh 'sshpass -p decathlon1 scp -r -o StrictHostKeyChecking=no /usr/share/tomcat/.jenkins/workspace/cicd-documentation/source/* ydeng@10.50.12.135:/var/lib/rancher/volumes/rancher-ebs/cicd-docs'
                }
            }
        }

    }
}
