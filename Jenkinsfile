pipeline {
    agent none

    tools {
        maven 'mymaven'
    }
    
    parameters{
        string(name:'ENV', defaultValue:'Test', description:'Version to deploy')
        booleanParam(name: 'executeTests', defaultValue:true , description:'Decide to run test cases')        
        choice(name:'APPVERSION' , choices: ['1.1','1.2','1.3'], description:'Select application version')
    }

    environment{
         BUILD_SERVER='ubuntu@43.205.228.232'
                 
    }
    
    stages {
        stage('Checkout') {
            agent any
            steps {
                git url: 'https://github.com/AbhishekSaharawat/Addressbook.git', branch: 'main'
                stash name: 'source-code', includes: '**/*'
            }
        }

        stage('Compile') {
            agent any
            steps {
                unstash 'source-code'
                echo "Compiling Job in ${params.ENV} Environment"
                sh 'mvn compile'
            }
        }

        stage('Code Review') {
            agent any
            steps {
                unstash 'source-code'
                echo 'Code Review Under Progress'
                sh 'mvn pmd:pmd'
            }
        }

        stage('Unit Test') {
            agent any
            
            steps {
                unstash 'source-code'
                echo 'Unit Testing in Progress'                
                sh 'mvn test'
            }
          //  post {
          //      always {
          //          junit 'target/surefire-reports/*.xml'
          //      }
          //  }
        }

        // stage('Coverage Analysis') {
        //     agent any
        //     steps {
        //         unstash 'source-code'
        //         echo 'Coverage Analysis in Progress'
        //         sh 'mvn verify'
        //     }
        // }

        stage('Packaging') {
         //   agent { label 'JenkinsSlave' }
            agent any
            steps{
              script {
                sshagent(['JenkinsSlave'])
                unstash 'source-code'
                sh "scp -o StrictHostKeyChecking=no server-script.sh ${BUILD_server}:/home/ubuntu"
                sh "ssh -o StrictHostKeyChecking=no ${BUILD_SERVER} 'bash ~/server-script.sh'" 
                //   echo "Packaging in Progress for code version ${params.APPVERSION}"
                // sh 'mvn package'
               }
            }  
        }

        stage('Publish To JFrog') {
            agent {label 'JenkinsSlave'}
            input {
                message "Do you want to Publish to JFrog"
                ok "Yes, Publish"
            }
            steps {
                unstash 'source-code'
                echo 'Publish to JFrog in Progress'
                sh 'mvn -X -U deploy -s settings.xml'
            }
        }
    }
}

