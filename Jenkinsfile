pipeline {
	agent none 
	stages {
		stage('Build') {
			agent {
                docker { 
					image 'node:18.12.0' 
					args '-u root:root -v $HOME/workspace/devops:/devops'
				}
            }
            steps {
				sh 'ls'
                sh 'npm --version'
				sh 'npm i -g @nestjs/cli@9.1.4'
				sh 'nest info'
            }
		}
	}
}
