# Powershell scripts for Docker

It assumes that you have created initial infrastructure (ECS Windows Cluster, Service) and setup appropriate IAM roles for ECS.

You will need to run this on Windows 2016 server with Docker installed.

Run "./setup.ps1" which will do the following tasks for you:

1) Create "content" directory for your web application:

c:\work\docker\content

2) Place Dockerfile in here:

c:\work\docker\Dockerfile

3) Place update-service.ps1 in here:

c:\work\scripts\update-service.ps1

After that, you can use the script to update your service with new task definitions and images built from Dockerfile:

`$update-service.ps1 -aws_account_number YOUR_AWS_ACCOUNT_NUMBER -image_name IMAGE_NAME -service_name SERVICE_NAME -cluster_name CLUSTER_NAME -task_definition_name TASK_DEFINITION_NAME -region AWS_REGION`
