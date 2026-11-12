# DEVOPS Documentation

## 1. Project Overview

This project demonstrates the containerization, automation, and deployment of a Full Stack Application using Docker, Jenkins, AWS EC2, and Terraform.

The application consists of:

- **Backend:** Django REST API
- **Frontend:** React with Vite and TypeScript
- **Containerization:** Docker
- **CI/CD:** Jenkins Pipeline
- **Container Registry:** Docker Hub
- **Cloud Infrastructure:** AWS EC2
- **Infrastructure as Code:** Terraform

### Project Objectives

1. Containerize the Django backend and React frontend.
2. Build optimized Docker images using multi-stage builds.
3. Automate the build and deployment process using Jenkins.
4. Push Docker images to Docker Hub.
5. Deploy the application on an AWS EC2 instance.
6. Document setup procedures and troubleshooting challenges.

---

## 2. Project Directory Structure

```text
Full Stack Application/
│
├── backend/
│   ├── Dockerfile
│   ├── .dockerignore
│   ├── requirements.txt
│   └── Django application files
│
├── frontend/
│   ├── Dockerfile
│   ├── .dockerignore
│   └── React application files
│
├── terraform/
│   ├── provider.tf
│   ├── security-group.tf
│   └── ec2.tf
│
├── docker-compose.yml
├── Jenkinsfile
├── README.md
└── DEVOPS.md
```

---

## 3. Prerequisites

The following tools are required:

| Tool | Purpose |
|---|---|
| Git | Source code management |
| Docker | Application containerization |
| Docker Compose | Multi-container configuration |
| Jenkins | CI/CD automation |
| AWS EC2 | Cloud infrastructure |
| Terraform | Infrastructure provisioning |
| Docker Hub | Docker image registry |
| SSH | Remote server access |

---

## 4. Local Environment Setup

### Step 1: Clone the Repository

```bash
git clone https://github.com/pranit-butale/DevOps-fullstack-assignment.git

cd "DevOps-fullstack-assignment/Full Stack Application"
```

### Step 2: Verify Docker Installation

```bash
docker --version
docker compose version
```

### Step 3: Build Docker Images

Build the backend image:

```bash
docker build -t devops-backend ./backend
```

Build the frontend image:

```bash
docker build -t devops-frontend ./frontend
```

### Step 4: Verify Docker Images

```bash
docker images
```

### Step 5: Run Docker Containers

Backend:

```bash
docker run -d \
  --name django_backend \
  -p 8000:8000 \
  devops-backend
```

Frontend:

```bash
docker run -d \
  --name react_frontend \
  -p 80:8080 \
  devops-frontend
```

### Step 6: Verify Running Containers

```bash
docker ps
```

### Step 7: View Container Logs

Backend logs:

```bash
docker logs django_backend
```

Frontend logs:

```bash
docker logs react_frontend
```

---

## 5. Docker Hub Configuration

Docker Hub is used to store and distribute the application images.

### Step 1: Login to Docker Hub

```bash
docker login
```

### Step 2: Tag Backend Image

```bash
docker tag devops-backend \
pranit-butale/devops-backend:latest
```

### Step 3: Tag Frontend Image

```bash
docker tag devops-frontend \
pranit-butale/devops-frontend:latest
```

### Step 4: Push Images

```bash
docker push pranit-butale/devops-backend:latest

docker push pranit-butale/devops-frontend:latest
```

### Step 5: Verify Images

Open Docker Hub and verify that both repositories contain the pushed images.

---

## 6. Jenkins CI/CD Configuration

Jenkins automates the application build, image publishing, and deployment process.

### Jenkins Pipeline Stages

**Stage 1 – Pull Source Code**

Jenkins fetches the application source code from GitHub.

**Stage 2 – Build Docker Images**

Jenkins builds Docker images for:

- Django Backend
- React Frontend

**Stage 3 – Push Docker Images**

Jenkins authenticates with Docker Hub and pushes both images to their respective repositories.

**Stage 4 – Deploy Application**

Jenkins connects to the deployment EC2 instance using SSH.

It pulls the latest pipeline-tagged images and starts the application containers.

### Jenkins Credentials

The following credentials are configured in Jenkins:

| Credential ID | Description |
|---|---|
| dockerhub-credentials | Docker Hub username and access token |
| deployment-ssh | Deployment EC2 SSH private key |

Credentials are stored in Jenkins Credentials Manager instead of hardcoding passwords or private keys in the pipeline.

### Pipeline Execution

1. Open the Jenkins Dashboard.
2. Select the Assessment pipeline job.
3. Click Build Now.
4. Open Console Output.
5. Verify all four stages.
6. Check the deployment EC2 instance.

---

## 7. AWS EC2 Deployment

Two EC2 instances are used in this implementation.

| Instance | Purpose |
|---|---|
| Jenkins EC2 | CI/CD automation and Docker image build |
| Deployment EC2 | Running the application containers |

### Deployment Server Setup

Connect to the deployment EC2 instance:

```bash
ssh -i pranitkey.pem ubuntu@<DEPLOYMENT_EC2_PUBLIC_IP>
```

Update the system:

```bash
sudo apt update -y
```

Install Docker:

```bash
sudo apt install docker.io -y
```

Start Docker:

```bash
sudo systemctl enable --now docker
```

Add the Ubuntu user to the Docker group:

```bash
sudo usermod -aG docker ubuntu
```

Reconnect to the server and verify:

```bash
docker --version
docker ps
```

### Verify Deployment

```bash
docker ps
```

Check backend logs:

```bash
docker logs django_backend
```

Check frontend logs:

```bash
docker logs react_frontend
```

Access the frontend using:

```text
http://<DEPLOYMENT_EC2_PUBLIC_IP>
```

---

## 8. Terraform Infrastructure

Terraform is used to provision AWS infrastructure.

### Infrastructure Components

- AWS provider configuration
- EC2 instance
- AWS Security Group

### Security Group Rules

| Port | Protocol | Purpose |
|---|---|---|
| 22 | TCP | SSH access |
| 80 | TCP | HTTP traffic |
| 443 | TCP | HTTPS traffic |

Only the required inbound ports are allowed by the security group.

### Terraform Commands

Initialize Terraform:

```bash
terraform init
```

Validate configuration:

```bash
terraform validate
```

Review infrastructure changes:

```bash
terraform plan
```

Create infrastructure:

```bash
terraform apply
```

Destroy infrastructure when no longer required:

```bash
terraform destroy
```

---

## 9. Troubleshooting Challenges and Resolutions

During the implementation, multiple configuration and deployment issues were encountered.

### Challenge 1: Docker Command Not Found in Jenkins

**Problem:**

The Jenkins pipeline failed during the Docker build stage.

Error:

```text
docker: not found
```

**Root Cause:**

Docker was not installed on the Jenkins EC2 instance.

**Resolution:**

Installed Docker:

```bash
sudo apt update -y
sudo apt install docker.io -y
```

Started Docker:

```bash
sudo systemctl enable --now docker
```

Added Jenkins to the Docker group:

```bash
sudo usermod -aG docker jenkins
```

Restarted Jenkins:

```bash
sudo systemctl restart jenkins
```

Verified Docker access:

```bash
sudo -u jenkins docker ps
```

### Challenge 2: Docker Compose Command Not Found

**Problem:**

The following error occurred:

```text
docker: unknown command: docker compose
```

**Root Cause:**

The Docker Compose V2 plugin was not installed on the Jenkins EC2 instance.

**Resolution:**

Install the Compose plugin:

```bash
sudo apt update

sudo apt install docker-compose-v2 -y
```

Verify:

```bash
docker compose version
```

**Alternative Implementation:**

The Jenkins pipeline can use normal Docker commands instead of Docker Compose:

```bash
docker build
docker tag
docker push
docker pull
docker run
```

This approach was selected for the Jenkins build and deployment stages.

### Challenge 3: Jenkins Built-In Node Went Offline

**Problem:**

The Jenkins Built-In Node became offline because of the temporary filesystem space threshold.

**Root Cause:**

Jenkins detected insufficient free temporary disk space.

**Resolution:**

Adjusted the Free Temp Space Threshold and Warning Threshold under Jenkins Node Configuration and brought the Built-In Node online again.

### Challenge 4: Jenkins Service Restart Interrupted Pipeline

**Problem:**

The pipeline stopped after Jenkins was restarted.

Error:

```text
wrapper script does not seem to be touching the log file
```

**Root Cause:**

Restarting Jenkins during pipeline execution interrupted the running shell process.

**Resolution:**

Wait for Jenkins to become fully active before starting a new pipeline execution. Avoid restarting Jenkins while a build is running.

### Challenge 5: Docker Build Configuration Verification

**Problem:**

Docker builds require valid Dockerfiles, dependency files, and correct build contexts.

**Resolution:**

Verified the project directory structure, Dockerfiles, and backend requirements before executing the build commands.

---

## 10. Application Verification

After successful deployment, verify the following:

### Docker Verification

```bash
docker images
docker ps
```

### Container Logs

```bash
docker logs django_backend

docker logs react_frontend
```

### Frontend Access

```text
http://<DEPLOYMENT_EC2_PUBLIC_IP>
```

### Backend Access

```text
http://<DEPLOYMENT_EC2_PUBLIC_IP>:8000
```

The backend endpoint depends on the Django URL configuration.

---

## 11. Security Considerations

- Store Docker Hub credentials in Jenkins Credentials Manager.
- Do not commit AWS access keys, passwords, or private SSH keys.
- Use non-root users in Docker containers.
- Use multi-stage Docker builds.
- Maintain `.dockerignore` files.
- Restrict SSH access to trusted IP addresses.
- Allow only the required inbound security group ports.
- Use public Docker Hub repositories for public image distribution as required by the assignment.

---

## 12. Conclusion

This project demonstrates a complete DevOps workflow for a full-stack application.

Docker is used for application containerization, Jenkins automates the CI/CD process, Docker Hub stores application images, AWS EC2 provides the deployment environment, and Terraform provisions cloud infrastructure.

The implementation also covers troubleshooting, environment configuration, container verification, and deployment documentation.

**Project Repository:**

https://github.com/pranit-butale/DevOps-fullstack-assignment

**Docker Hub:**

https://hub.docker.com/u/pranit-butale
