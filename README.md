# Spotify-clone-byJenkins
clone of spotfiy , hosted on aws , using jenkins docker , we will also use sonarqube and trivy here , add monitroing using prometheus and grafana 


TOOLS:
Node.js
AWS
JENKINS
DOCKER
SONARQUBE
TRIVY
PROMETHEUS
GRAFANA
MORE ?

# Deploy Spotify Clone on Cloud using Jenkins - My Project 


### **PHASE 1  Setup**

**Step 1: Launch EC2 (Ubuntu 22.04):**

-  Provision an EC2 instance on AWS with Ubuntu 22.04.
    - Or use my commands , for creating an instance in aws
    -  Connect to the instance using SSH.

**Step 2: Clone the Code**:
    - Update all the packages and then clone the code.
     - Clone your application's code repository onto the EC2 instance:


**Step 3: Install Docker and Run the App Using a Container:**

- Set up Docker on the EC2 instance:
    
    ```bash
    
    sudo apt-get update
    sudo apt-get install docker.io -y
    sudo usermod -aG docker $USER  # Replace with your system's username, e.g., 'ubuntu'
    newgrp docker
    sudo chmod 777 /var/run/docker.sock
    ```
    
- Build and run your application using Docker containers:
    
    ```bash
    docker build -t spotify .
    docker run -d --name spotify -p 8081:80 spotify:latest
    
    #to delete
    docker stop <containerid>
    docker rmi -f spotify
    ```


**Phase 2: Security**

1. **Install SonarQube and Trivy:**
    - Install SonarQube and Trivy on the EC2 instance to scan for vulnerabilities.
        
        sonarqube
        ```
        docker run -d --name sonar -p 9000:9000 sonarqube:lts-community
        ```


        To acess:
      publicIP:9000 admin/admin deafult


      Install tivy :


       ```
        sudo apt-get install wget apt-transport-https gnupg lsb-release -y
        wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
        echo deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main | sudo tee -a /etc/apt/sources.list.d/trivy.list
        sudo apt-get update -y
        sudo apt-get install trivy -y        
        ```

       scan image
   ```
      trivy image <imageID>
   ```   

**Phase 3: Jenkins**


1. **Install Jenkins for Automation:**
    - Install Jenkins on the EC2 instance to automate deployment:
    Install Java we need install java first 
    
    ```bash
    sudo apt update
    sudo apt install fontconfig openjdk-17-jre
    java -version
    openjdk version "17.0.8" 2023-07-18
    OpenJDK Runtime Environment (build 17.0.8+7-Debian-1deb12u1)
    OpenJDK 64-Bit Server VM (build 17.0.8+7-Debian-1deb12u1, mixed mode, sharing)
    
    #jenkins
    sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
    https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
    echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
    https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
    /etc/apt/sources.list.d/jenkins.list > /dev/null
    sudo apt-get update
    sudo apt-get install jenkins
    sudo systemctl start jenkins
    sudo systemctl enable jenkins
    ```

    - Acess to jenkins by public IP :8080
  
     2.Install Necessary Plugins in Jenkins:

Goto Manage Jenkins →Plugins → Available Plugins →

Install below plugins

1 Eclipse Temurin Installer (Install without restart)

2 SonarQube Scanner (Install without restart)

3 NodeJs Plugin (Install Without restart)

4 Docker
Docker Commons
Docker Pipeline
Docker API
docker-build-step
5 OWASP Dependency-Check. 


Add DockerHub Credentials:

```
To securely handle DockerHub credentials in your Jenkins pipeline, follow these steps:
Go to "Dashboard" → "Manage Jenkins" → "Manage Credentials."
Click on "System" and then "Global credentials (unrestricted)."
Click on "Add Credentials" on the left side.
Choose "Secret text" as the kind of credentials.
Enter your DockerHub credentials (Username and Password) and give the credentials an ID (e.g., "docker").
Click "OK" to save your DockerHub credentials.
```
Now we can use ass Jenkinsfile as new job in jenkins 


I find that we need do 
```
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins

```

**Phase 4: Monitoring **

    1.Install prometheus i had script for that

    git clone  https://github.com/Michal-Devops/Spotify-clone-byJenkins.git

    cd Spotify-clone-byJenkins/monitoring 
    chmod +x install-prometheus.sh
    ./install-prometheus.sh


    2.Install node-exporter from script 

    so 
    git pull -v
    cd Spotify-clone-byJenkins/monitoring 
    chmod +x node-exporter-install.sh
    ./node-exporter-install.sh
    

    So now it is time to edit prometheus.yml 
    for my configuration I prepared this file for myself earlier in my
    repo so just download the repo and copy the file 
       ```
     cd  Spotify-clone-byJenkins/monitoring
     sudo cp prometheus.yml /etc/prometheus/prometheus.yml
     promtool check config /etc/prometheus/prometheus.yml
     curl -X POST http://localhost:9090/-/reload


     3.Install Grafana

     I had script for that 

     cd Spotify-clone-byJenkins/monitoring
     chmod +x chmod +x grapfana.sh
     ./grapfana.sh
     That will be acess on IP:3000 admin/admin


    4. We need to add Jenkins Plugins to Prometheus 
    ```
        Go to manage jenkis , plugins , avaliable and find prometheus metrics 


    5. Grafana Dashboards 

        We click imprort dashboard to node exporter we write id 1860
        to jenkins we write id 9964

