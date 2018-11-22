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
        stage('Deploy To Rancher'){
            steps {
                withEnv(["BUILD_NUMBER=${env.BUILD_NUMBER}"]){
                    
                }
            }
        }

    }
}
