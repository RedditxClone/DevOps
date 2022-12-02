pipeline {
	agent any 
	stages {
		stage('Fetch Repos') {
            steps {
				withCredentials([gitUsernamePassword(credentialsId: 'mahmed-amer-key-1', gitToolName: 'git-tool')]) {
					sh '''
						git checkout master
						git submodule update --init --recursive
						git pull --recurse-submodules
						echo "All repos are here"
					'''
				}
            }
		}
		stage('Build Backend Development Image'){
			steps{
				sh '''
					cp backend.Dockerfile ./Backend/Dockerfile
					cd Backend
					docker build -t backend:dev .
				'''
			}
		}
		stage('Build Frontend Development Image'){
			steps{
				sh '''
					cp frontend.Dockerfile ./Frontend/reddit-front/Dockerfile
					cp frontend.nginx.conf ./Frontend/reddit-front/nginx.conf
					cd Frontend/reddit-front
					docker build -t frontend:dev .
				'''
			}
		}
		stage('Build Cross-Platform Development Image'){
			environment {
				BASE_URL = credentials('BASE_URL')
    		}
			steps{
				sh '''
					cp cross.Dockerfile ./Cross-Platform/reddit/Dockerfile
					cp cross.nginx.conf ./Cross-Platform/reddit/nginx.conf
					cd Cross-Platform/reddit
					docker build -t cross:dev .
				'''
			}
		}		
		stage('Run Dev Containers For Testing') {
			environment {
				MONGO_INITDB_ROOT_USERNAME = credentials('MONGO_INITDB_ROOT_USERNAME')
        		MONGO_INITDB_ROOT_PASSWORD = credentials('MONGO_INITDB_ROOT_PASSWORD')
				JWT_SECRET = credentials('JWT_SECRET')
				BASE_URL = credentials('BASE_URL')
				REACT_APP_BASE_URL = credentials('BASE_URL')
				FORGET_PASSWORD_SECRET = credentials('FORGET_PASSWORD_SECRET')
				SU_USERNAME = credentials('SU_USERNAME')
				SU_EMAIL = credentials('SU_EMAIL')
				SU_PASS = credentials('SU_PASS')
    		}
			steps {
				sh '''
					export DB_CONNECTION_STRING=mongodb://$MONGO_INITDB_ROOT_USERNAME:$MONGO_INITDB_ROOT_PASSWORD@mongo-db-dev:27017 
					docker-compose -f 'docker-compose-dev.yml' -p 'swproject-dev' up -d
				'''
            }
		}		
		/*
		stage('Run Tests'){
			steps{
				sh '''
					echo "Starting Testing"
					echo "Testing..."
					echo "Testing Finished: Passed"
				'''
			}
		}
		*/
		/*
		stage('Build new images for production') {
            steps {
				sh '''
					cd Backend 
					docker build -t backend:prod ./devops.Dockerfile
					cd ../Frontend/reddit-front
					docker build -t frontend:prod ./devops.Dockerfile
					cd ../../Cross-Platform/reddit
					docker build -t  cross:prod ./devops.Dockerfile
					docker-compose up -d -f 'docker-compose-prod.yml' -p 'swproject-prod'
				'''
            }
		}
		*/	
	}
}
