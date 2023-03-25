pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: 'main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/ToryViktory/python-flask-webapp-quickstart']]])
            }
        }
        stage('Build') {
            steps {
                script {
                    sh 'pip -r requirements.txt'
                }
            }
        }
    }
}