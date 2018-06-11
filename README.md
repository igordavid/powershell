# Powershell scripts for Docker

It assumes that you have created initial infrastructure (ECS Windows Cluster, Service) and setup appropriate IAM roles for ECS.

You will need to run this on Windows 2016 server with Docker installed.

Create directory with your web application:

c:\work\docker\content

Place Dockerfile in here:

c:\work\docker\Dockerfile

Put update-service.ps1 script in here:

c:\work\scripts

Use the script:

$update-service.ps1 -aws_account_number YOUR_AWS_ACCOUNT_NUMBER -image_name IMAGE_NAME -service_name SERVICE_NAME -cluster_name CLUSTER_NAME -task_definition_name TASK_DEFINITION_NAME -region AWS_REGION
