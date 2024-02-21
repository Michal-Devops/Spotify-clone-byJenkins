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
        sudo apt-get install wget apt-transport-https gnupg lsb-release
        wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
        echo deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main | sudo tee -a /etc/apt/sources.list.d/trivy.list
        sudo apt-get update
        sudo apt-get install trivy        
        ```

       scan image
   ```
      trivy image <imageID>
   ```   

