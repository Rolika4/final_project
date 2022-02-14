pipeline {
    agent any
        environment {
            AWS_ACCESS_KEY = credentials('accesskey')
            AWS_SECRET_KEY = credentials('secretkey')
            AWS_KEY = credentials('aws')
            DOCKER = credentials('Docker')
        }
    stages {
        stage('Test') {
            steps {
            echo "----------------------------------------------TEST----------------------------------------------"
            sh 'mkdir project'
            dir('project') {
            git branch: 'main', url: 'git@github.com:Rolika4/Real_World.git', credentialsId: 'github_key'
            } 
            sh 'sleep 5'
            echo "----------------------------------------------PASS----------------------------------------------"   
            }
        }
        stage('Build') {
            steps {
            echo "----------------------------------------------BUILD----------------------------------------------"  
            sh 'terraform -chdir=build init'
            sh 'terraform -chdir=build apply -auto-approve -var="key=$AWS_KEY" -var="accesskey=$AWS_ACCESS_KEY" -var="secretkey=$AWS_SECRET_KEY" -var="DockerLogin=$DOCKER_USR" -var="DockerPsw=$DOCKER_PSW"'
            sh 'terraform -chdir=build destroy -auto-approve -var="accesskey=$AWS_ACCESS_KEY" -var="secretkey=$AWS_SECRET_KEY" '
            echo "----------------------------------------------PASS-----------------------------------------------"
            
            }
        }
        stage('Deployy') {
            steps {
            echo "----------------------------------------------DEPLOY----------------------------------------------" 
            sh 'terraform -chdir=deploy init'
            sh 'terraform -chdir=deploy apply -auto-approve -var="key=$AWS_KEY" -var="accesskey=$AWS_ACCESS_KEY" -var="secretkey=$AWS_SECRET_KEY" -var="DockerLogin=$DOCKER_USR" -var="DockerPsw=$DOCKER_PSW"'
            sh 'terraform -chdir=deploy destroy -auto-approve -var="accesskey=$AWS_ACCESS_KEY" -var="secretkey=$AWS_SECRET_KEY" '  
            echo "----------------------------------------------PASS------------------------------------------------"
            cleanWs()
            }
        }
    }
}
