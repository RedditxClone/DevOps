pipeline {
	agent any 
	stages {
		stage('Test') {
            steps {
				withCredentials([gitUsernamePassword(credentialsId: 'mahmed-amer-key-1', gitToolName: 'git-tool')]) {
					sh '''
						ls -a
						git checkout master
						git submodule update --init --recursive
						git pull --recurse-submodules
						ls -a
						cd Backend
						ls -a
						cd ../Frontend
						ls -a
						cd ../Cross-Platform
						ls -a
						cd ../Testing 
						ls -a
					'''
				}
            }
		}
	}
}
