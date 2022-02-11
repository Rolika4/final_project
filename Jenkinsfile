pipeline {
    agent any
    stages {
        stage('Test') {
            environment {
            AWS_ACCESS_KEY     = credentials('accesskey')
            AWS_SECRET_KEY = credentials('secretkey')
            AWS_KEY = credentials('aws')
            }
            steps {
            echo "Testing"
            echo "My key is '$AWS_ACCESS_KEY' "
            git branch: 'main', url: 'git@github.com:Rolika4/Real_World.git', credentialsId: 'github_key'
            sh 'terraform -chdir=build init'
            sh 'terraform -chdir=build apply -auto-approve -var="key=$AWS_KEY" -var="accesskey=$AWS_ACCESS_KEY" -var="secretkey=$AWS_SECRET_KEY"'
            }
        }
        stage('Deploy') {
            steps {
            sh "ls -l "   
            }
        }
    }
}
