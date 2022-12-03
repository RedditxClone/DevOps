pipeline {
	agent any 
	stages {
		stage('Fetch Repos') {
            steps {
				withCredentials([gitUsernamePassword(credentialsId: 'mahmed-amer-key-1', gitToolName: 'git-tool')]) {
					sh '''
						git checkout master
						git submodule update --init --recursive
						cd Backend 
						git checkout master
						git pull
						cd ../Frontend 
						git checkout master
						git pull
						cd ../Cross-Platform 
						git checkout master
						git pull
						cd ../Testing 
						git checkout master
						git pull
						echo "All repos are here"
					'''
				}
            }
		}
		stage('Build DEV Backend Development Image'){
			steps{
				sh '''
					cp backend.Dockerfile ./Backend/Dockerfile
					cd Backend
					docker build -t backend:dev .
				'''
			}
		}
		stage('Build DEV Frontend Development Image') {
			steps{
				sh '''
					export REACT_APP_BASE_URL="http://back-dev:3000"
					cp frontend.Dockerfile ./Frontend/reddit-front/Dockerfile
					cd Frontend/reddit-front
					rm .env -f
					echo REACT_APP_BASE_URL=$REACT_APP_BASE_URL > .env
					docker build -t frontend:dev .
				'''
			}
		}
		stage('Build DEV Cross-Platform Development Image'){
			steps{
				sh '''
					cp cross.Dockerfile ./Cross-Platform/reddit/Dockerfile
					cd Cross-Platform/reddit
					export BASE_URL="http://back-dev:3000/api"
					docker build -t cross:dev .
				'''
			}
		}
		stage('Build DEV Testing Image') {
			steps{
				sh '''
					cp testing.Dockerfile ./Testing/Dockerfile
					cd Testing
					rm .env -f
					echo BASE_URL=http://front-dev > .env
					docker build -t testing:dev .
				'''
			}
		}
		stage('Run Dev Containers For Testing') {
			environment {
				MONGO_INITDB_ROOT_USERNAME = credentials('MONGO_INITDB_ROOT_USERNAME')
        		MONGO_INITDB_ROOT_PASSWORD = credentials('MONGO_INITDB_ROOT_PASSWORD')
				JWT_SECRET = credentials('JWT_SECRET')
				FORGET_PASSWORD_SECRET = credentials('FORGET_PASSWORD_SECRET')
				SU_USERNAME = credentials('SU_USERNAME')
				SU_EMAIL = credentials('SU_EMAIL')
				SU_PASS = credentials('SU_PASS')
    		}
			steps {
				sh '''
					export BASE_URL="http://back-dev:3000"
					export REACT_APP_BASE_URL="http://back-dev:3000"
					export DB_CONNECTION_STRING=mongodb://$MONGO_INITDB_ROOT_USERNAME:$MONGO_INITDB_ROOT_PASSWORD@mongo-db-dev:27017 
					docker-compose -f 'docker-compose-dev.yml' -p 'swproject-dev' up -d
				'''
            }
		}
		/*
		stage('Run Tests') {
			steps{
				sh '''
					docker run -w /e2e testing:dev
				'''
			}
		}
		*/
		stage('Remove Dev Containers For Testing') {
			steps{
				sh '''
					docker-compose -f 'docker-compose-dev.yml' -p 'swproject-dev' stop
					docker-compose -f 'docker-compose-dev.yml' -p 'swproject-dev' down
				'''
			}
		}
		stage('Build PROD Backend Development Image'){
			steps{
				sh '''
					cp backend.Dockerfile ./Backend/Dockerfile
					cd Backend
					docker build -t backend:prod .
				'''
			}
		}
		stage('Build PROD Frontend Development Image') {
			environment {
				REACT_APP_BASE_URL = credentials('BASE_URL')
    		}
			steps{
				sh '''
					cp frontend.Dockerfile ./Frontend/reddit-front/Dockerfile
					cd Frontend/reddit-front
					rm .env -f
					echo REACT_APP_BASE_URL=$REACT_APP_BASE_URL > .env
					docker build -t frontend:prod .
				'''
			}
		}
		stage('Build PROD Cross-Platform Development Image'){
			environment {
				REACT_APP_BASE_URL = credentials('BASE_URL')
    		}
			steps{
				sh '''
					cp cross.Dockerfile ./Cross-Platform/reddit/Dockerfile
					cd Cross-Platform/reddit
					export BASE_URL=$REACT_APP_BASE_URL/api
					docker build -t cross:prod .
				'''
			}
		}
		stage('Run New Prod Containers') {
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
					export DB_CONNECTION_STRING=mongodb://$MONGO_INITDB_ROOT_USERNAME:$MONGO_INITDB_ROOT_PASSWORD@mongo-db-prod:27017 
					docker build -t myproxy:prod -f proxy.Dockerfile .
					docker-compose -f 'docker-compose-prod.yml' -p 'swproject-prod' up -d
				'''
            }
		}
	}
}
