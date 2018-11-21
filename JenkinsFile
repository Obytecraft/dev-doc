def message = "";
def author = "";

def getLastCommitMessage = {
    message = sh(returnStdout: true, script: 'git log -1 --pretty=%B').trim()
}

def getGitAuthor = {
    def commit = sh(returnStdout: true, script: 'git rev-parse HEAD')
    author = sh(returnStdout: true, script: "git --no-pager show -s --format='%an' ${commit}").trim()
}

pipeline{
      agent any
        stage ('Check Code') {
            steps
            {
                script{
                    echo 'Check code';
                    checkout sum

                    if (env.BRANCH_NAME == 'master') {
                        echo 'Okay';                    }
                }
            }
        }
    

        stage('build docker image and upload'){
            steps {
                echo 'build docker image and upload'
                echo 'version number : ${image_version}'
                script {
                    def image
                    image = docker.build("dev-induction_app:latest", ".")

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

    stage('Prepare and deploy on Rancher') {
        when { branch 'master' }
            steps{
               echo "downloading cli component"
               sh "wget http://nexus.osiris.withoxylane.com/service/local/repositories/utils/content/rancher/rancher-compose-linux-amd64-${compose_version}.tar.gz -O - | tar -zx"
               sh "wget http://nexus.osiris.withoxylane.com/service/local/repositories/utils/content/rancher/rancher-linux-amd64-${cli_version}.tar.gz -O - | tar -zx"
               sh "mv rancher-compose-${compose_version}/rancher-compose . && rm -rf rancher-compose-${compose_version}"
               sh "mv rancher-${cli_version}/rancher . && rm -rf rancher-${cli_version}"
            }
    }

    stage('Deploy on Pre-production') {
        when { branch 'master' }
            steps{
                script {
                    try {
                        sh "./rancher --url http://rancher.preprod.subsidia.org --access-key B18A853A846D925F4883 --secret-key GA89Hzgc9tBN6gpCGHi5APDvX6ABqWvC6ALEh83o export ${stack_name}"
                        sh "mv ${stack_name}/*-compose.yml ."
                    } catch (Exception err) {
                        echo "Stack not found"
                    }
                    sh "sed -i \"s/${image_name}:.*\$/${image_name}:${image_version}/g\" docker-compose.yml"
                    sh "./rancher-compose --project-name ${stack_name} --url http://rancher.preprod.subsidia.org --access-key B18A853A846D925F4883 --secret-key GA89Hzgc9tBN6gpCGHi5APDvX6ABqWvC6ALEh83o --verbose up -d --force-upgrade --pull --confirm-upgrade benefit"
                }
            }
    }
}
  