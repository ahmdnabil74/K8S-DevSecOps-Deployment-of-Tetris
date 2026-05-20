## Directories 📂

1. **EKS-TF:** Explore Terraform scripts for deploying EKS clusters on AWS.
2. **Jenkins-Pipeline-Code:** Jenkins pipeline code for automated CI/CD.
3. **Jenkins-Server-TF:** Terraform scripts for provisioning Jenkins servers on AWS EC2.
4. **Manifest-file:** Kubernetes manifest files for Tetris application deployment.
5. **Tetris-V1:** Initial version of the Tetris game application.
6. **Tetris-V2:** Enhanced version of the Tetris game application.



## Tools Explored 🛠️
1. **Jenkins:** Automated CI/CD pipelines
2. **ArgoCD:** Continuous deployment to Kubernetes
3. **Kubernetes:** Orchestration for containerized applications
4. **Trivy:** Container vulnerability scanner
5. **OWASP Dependency-Check:** Ensuring secure dependencies
6. **Docker:** Containerized application deployment
7. **SonarQube:** Unveiling code quality insights
8. **Terraform:** Infrastructure as Code for AWS EKS



## Phase 1 : terraform
before init terraform
create s3 dev-ahmed-tf-bucket
``` bash
aws login
aws configure
terraform init
terraform plan -var-file="variables.tfvars"
terraform apply -auto-approve -var-file="variables.tfvars"
```

## Phase 2 : Installing Tools
1. **Java:** 
2. **Jenkins:** 
3. **Docker:** 
4.  Run Docker 
5. **Terraform:** 
5. **Kubectl** 
6. **AWS CLI**
7. **Trivy**

## Phase 3 : Jenkins
unlock account 
```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```
### install requrired plugins
- **AWS Credentials**
- **Pipeline: AWS Steps**
- **stage view**
- **rebuilder**
- Docker
- Docker commons
- Docker pipeline
- Docker api
- nodejs 
- owasp
- sonarqube 

### configure requrired credintials
- Add AWS Credentials
- Id, Access Key ID, Secret Access Key

### create job in jenkins and deploy eks using jenkins
- job : eks-deploy-aws
- add pipeline and build it
- build with [parameter: apply]


## Phase 4 : Sonarqube
### create token
- administration -> security -> users : sonar-token

### create webhooks
- configuration -> webhooks
-- Name: jenkins 
-- url : http://52.58.166.187:8080/sonarqube-webhook/

### create credentials
- credentials for sonarqube in jenkins
- secret text type 
- secret : from token that created in sonarqube
- id: sonar-token

### configure tools

#### nodejs
- at nodejs -> name: nodejs , version: 16.2.0

#### dependency check
- name : DP-Check
- install automatically : from github

#### docker 
- name docker and install from dockerhub

#### sonarqube scanner 
- name: sonar-server 


### configure system
#### sonarqube server
- name: sonar-scanner and authentiaction with sonarqube token
- url: http://52.58.166.187:9000/ 


## phase 5 : deploy source code via jenkins on EKS

### sonarqube
#### create local project
- name and key : tertis
- branch : master
- follow instances 
- choose locally and use exisiting token 

#### generate token at github
- Note : tertis-project
- choose repo and workflow
- add secret text Credentials in jenkins with token and id : github

#### generate token at dockerhub
- tertis project and 30 days with read and write


##### configure the EKS Cluster on the Jenkins Server
- aws configure
#### validate whether the EKS Cluster was successfully configured 
- kubectl get nodes

#### install helm
- curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-4 && chmod 700 get_helm.sh && ./get_helm.sh
- helm version

## phase 6 : argo cd
### install

- kubectl create namespace argocd
- kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/v2.4.7/manifests/install.yaml
- kubectl get pods -n argocd
- kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
- kubectl get svc -n argocd

### copy link pf LB
- There is one pre-requisite which is jq to get the password by using filtration.
``` bash
sudo apt install jq -y
```

- Store the ArgoCD DNS name in the variable
``` bash
export ARGOCD_SERVER=$(kubectl get svc argocd-server -n argocd -o json | jq -r '.status.loadBalancer.ingress[0].hostname')
```

- Run the below command to get the password.
``` bash
export ARGO_PWD=`kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d`
echo $ARGO_PWD
```

## phase 7 : configure ARGO CD 
### CREATE NEW APP
- NAME : tertis-APP
- COPY REPO URL
- path: Manifest-file
- https://kubernetes.default.svc/
- namespace : default 


- sudo apt-get install -y libatomic