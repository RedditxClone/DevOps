pipeline {
	agent any 
	stages {
		stage('Test') {
			agent {
                docker { 
					image 'node:18.12.0' 
					args '-u root:root'
				}
            }
            steps {
				sh 'ls'
				sh 'npm i -g @nestjs/cli@9.1.4'
				sh 'npm install'
				sh 'npm run start'
            }
		}
	}
}
