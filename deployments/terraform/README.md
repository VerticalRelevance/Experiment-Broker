# Deploying Experiment Broker

This document describes how to deploy the Experiment Broker using Terraform.

## Prerequisites

- [Terraform CLI](https://developer.hashicorp.com/terraform/install)
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

## Deployment Instructions
### CDK
TBD
### Terraform
There are two methods for deploying Experiment Broker through terraform. The first is to use the `terraform` CLI locally, and the second is to provision deploy the codepipeline infrastructure for deploying Experiment Broker through the AWS console.

You can run into issues with the first method depending on your OS, so the second method is recommended.

#### AWS Credentials
Before deploying Experiment Broker, you must configure your AWS credentials.

##### Setting Up Remote State Management
1. Clone the repository
2. Navigate to the `deployments/terraform/bootstrap` directory
3. Run the following commands:
```
terraform init
terraform validate
terraform plan
terraform apply
```
This will deploy the Experiment Broker provider infrastructure to your AWS environment, allowing state to be managed in the AWS environment.

##### Local Deployment
To deploy Experiment Broker Infrastructure to your AWS environment from your local machine:

1. Navigate to the `deployments/terraform/experiment-broker` directory
2. Run the following commands:
```
terraform init
terraform validate
terraform plan
terraform apply
```
This will deploy the Experiment Broker infrastructure to your AWS environment.

##### CodePipeline Deployment

To deploy Experiment Broker Infrastructure to your AWS environment from through AWS CodePipeline:

1. Navigate to the `deployments/terraform/experiment-broker` directory
2. Run the following commands:
```
terraform init
terraform validate
terraform plan
terraform apply
```
This will deploy the Experiment Broker CodePipeline infrastructure to your AWS environment.

3. Navigate to the AWS Console.
4. Navigate to CodeStar Connections.
5. Approve the connection, named 'experiment-broker-connection'. The connection is used to connect the CodePipeline to the GitHub repository. Ensure that the credentials used have access to the repository Experiment Broker is in.
6. Navigate to the CodePipeline service.
7. Click on the CodePipeline created, named 'experiment-broker-build-pipeline'.
8. Click on the 'Release Change' button to deploy the Experiment Broker infrastructure.
9. Manually Approve after the Plan stage is completed.

## Demo Instructions