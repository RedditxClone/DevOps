pipeline {
	agent any 
	stages {
		stage('Test') {
            steps {
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
