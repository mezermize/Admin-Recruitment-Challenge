# Admin-Recruitment-Challenge
Challenge from XpandIT - https://github.com/bdu-xpand-it/BDU-Recruitment-Challenges/wiki/Admin-Recruitment-Challenge

This guide provides step-by-step instructions to build and run a Docker container with Tomcat 8.5 on CentOS 7, with SSL/TLS enabled and a sample web app deployed.

## Requirements
- Docker installed on your system

## Steps to deploy the container 
### 1. Clone the Repository
- Clone this repository or download the necessary files into a directory on your local machine.

### 2. Generate SSL Certificates
- Open a terminal and navigate to the project directory;
- In the project directory run the script ``./create-cert.sh``

### 3. Build docker container
- In the project directory enter the command: ``docker build -t <docker_name> .``

### 4. Run docker container
- In terminal enter the command: ``docker run -d -p 4001:4001 <docker_name>``

### 5. Check if the container was created
  In terminal enter the command: ``docker ps``

### 6. Access the Sample App
Open your web browser and navigate to: https://localhost:4041/sample

You may need to bypass security warnings because the SSL certificate is self-signed.


## Files Included
- Script to create certificates
- Dockerfile
- README.md
- ca-cert.pem (CA public certificate)
- ca-key.pem (CA private key)
