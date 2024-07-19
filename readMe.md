# sampleIAC

This repository contains Infrastructure as Code (IAC) examples using Terraform and Kubernetes. The primary goal is to demonstrate the provisioning and management of cloud resources on Google Cloud Platform (GCP) and running GitHub Actions runners on a Kubernetes cluster.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Repository Structure](#repository-structure)
- [Getting Started](#getting-started)
    - [Clone the Repository](#clone-the-repository)
    - [Setup Environment Variables](#setup-environment-variables)
    - [Initialize Terraform](#initialize-terraform)
- [Usage](#usage)
    - [Deploying Infrastructure](#deploying-infrastructure)
    - [Destroying Infrastructure](#destroying-infrastructure)
- [Terraform Modules](#terraform-modules)
- [Kubernetes Resources](#kubernetes-resources)
- [GitHub Actions](#github-actions)
- [Contributing](#contributing)
- [License](#license)

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) v1.1.5 or later
- [Google Cloud SDK](https://cloud.google.com/sdk/docs/install) configured and authenticated
- [Kubectl](https://kubernetes.io/docs/tasks/tools/) configured to access your Kubernetes cluster
- [Helm](https://helm.sh/docs/intro/install/) v3 or later
- A Google Cloud Project with appropriate permissions
- A GitHub PAT (Personal Access Token) with repo and workflow permissions

## Repository Structure

```plaintext
sampleIAC/
├── infra/
│   └── GCP/
│       ├── terraform/
│       │   ├── FlaskAppExample/
│       │   ├── VM/
│       │   ├── bucket/
│       │   └── init/
│       └── Local/
│           └── Private Action Runners
└── README.md
```
### Folders
* **infra/GCP/terraform/:** Contains Terraform configurations for various GCP resources.
* **infra/Local/Private Action Runners/:** Contains configurations for setting up Minikube and Kubernetes resources for private action runners
* **README.md:** This file.

## Getting Started
### Clone the repository
```shell
git clone https://github.com/jco281/sampleIAC.git
cd sampleIAC
```
### Setup Environment Variables
Create a .env file in the root directory and add the necessary environment variables:
```dotenv
GOOGLE_CLOUD_PROJECT=your-project-id
GITHUB_PAT=your-github-pat
```
### Initialize Terraform
Navigate to the desired Terraform configuration directory and initialize Terraform:

```shell
cd infra/GCP/terraform/VM
terraform init
```
## Usage
### Deploying Infrastructure
To deploy the infrastructure, run the following command:
```shell
terraform apply -auto-approve
```
### Destroying Infrastructure
To destroy the deployed infrastructure, run:
```shell
terraform destroy -auto-approve
```
## Terraform Modules
* **FlaskAppExample:** Demonstrates deploying a Flask application on GCP.
* **VM:** Configures a virtual machine instance on GCP.
* **bucket:** Creates and manages a Google Cloud Storage bucket.
* **init:** Contains initialization scripts and configurations.
## Kubernetes Resources
The Local directory contains configurations to set up Minikube for local Kubernetes clusters and deploy resources using Helm. 
This is also used for the private action runners used to deploy the IaC to associated cloud provider.
## GitHub Actions
This repository includes a GitHub Actions workflow to automate the deployment of Terraform configurations and manage Kubernetes resources.
## Contributing
Contributions are welcome! Please open an issue or submit a pull request.
