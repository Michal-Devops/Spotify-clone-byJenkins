pipeline{
    agent any
    tools{
        jdk 'jdk17'
        nodejs 'node16'
    }
    environment {
        SCANNER_HOME=tool 'sonar-scanner'
    }
    stages {
        stage('clean workspace'){
            steps{
                cleanWs()
            }
        }
        stage('Checkout from Git'){
            steps{
                git branch: 'main', url: 'https://github.com/Michal-Devops/Spotify-clone-byJenkins.git'
            }
        }
        stage("Sonarqube Analysis"){
            steps{
                withSonarQubeEnv('sonar-server') {
                    sh "${SCANNER_HOME}/bin/sonar-scanner \
                    -Dsonar.projectKey=spotify \
                    -Dsonar.sources=. \
                    -Dsonar.host.url=http://35.169.69.128:9000 \
                    -Dsonar.login=sqp_147bf509adf6ab3493b4d895c18b5704b7ed2f4b"
                }
            }
        }
        stage('TRIVY FS SCAN') {
            steps {
                sh "trivy fs . > trivyfs.txt"
            }
        }
        stage("Docker Build & Push"){
            steps{
                script{
                   withDockerRegistry(credentialsId: 'docker', toolName: 'docker'){   
                       sh "docker build -t spotify ."
                       sh "docker tag spotify darin912/spotify:latest"
                       sh "docker push darin912/spotify:latest"
                    }
                }
            }
        }
        stage("TRIVY"){
            steps{
                sh "trivy image darin912/spotify:latest > trivyimage.txt" 
            }
        }
        stage('Deploy to container'){
            steps{
                sh 'docker run -d --name spotify -p 8081:80 darin912/spotify:latest'
            }
        }
    }
}
