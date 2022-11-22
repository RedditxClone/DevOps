pipeline {
	agent any 
	stages {
		stage('Test') {
            steps {
				withCredentials([gitUsernamePassword(credentialsId: 'mahmed-amer-key-1', gitToolName: 'git-tool')]) {
					sh '''
						ls -a
						git pull --recurse-submodules
						ls 
						cd Backend
						ls 
						cd ../Frontend
						ls 
						cd ../Cross-Platform
						ls 
						cd ../Testing 
						ls 
					'''
				}
            }
		}
	}
}
