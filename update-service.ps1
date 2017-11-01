# Powershell script to generate new Docker image (with the new code in c:\work\content), push it to ECR
# update task_definition.json with the new image name, 
# run "aws service_update task_definition.json" and delete old Task definition
#
# Igor David 
# October 2017

param (
    [Parameter(Mandatory=$true)][string]$aws_account_number,
    [Parameter(Mandatory=$true)][string]$image_name,
    [Parameter(Mandatory=$true)][string]$service_name,
    [Parameter(Mandatory=$true)][string]$cluster_name,
    [Parameter(Mandatory=$true)][string]$task_definition_name,
    [Parameter(Mandatory=$true)][string]$region
 )

Invoke-Expression -Command "docker build -t $image_name c:\work\docker"
Invoke-Expression -Command "aws ecr get-login --region $region > c:\work\scripts\docker-login.ps1"
Invoke-Expression -Command "c:\work\scripts\docker-login.ps1"
Invoke-Expression -Command "docker tag $($image_name):latest $($aws_account_number).dkr.ecr.$($region).amazonaws.com/ecr_poc:$($image_name)"
Invoke-Expression -Command "docker push $($aws_account_number).dkr.ecr.$region.amazonaws.com/ecr_poc:$($image_name)"

$old_task_definition = Invoke-Expression -Command "aws ecs list-task-definitions --region $region --query taskDefinitionArns --output text --family-prefix $($task_definition_name)"

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8


write-output @"
{
            "containerDefinitions": [
              {  
                "environment": [{
      "name": "SECRET",
      "value": "KEY"
    }],
                "name": "iis_server",
                "image": "$aws_account_number.dkr.ecr.$region.amazonaws.com/ecr_poc:$image_name",
                "cpu": 256,
                "memoryReservation": 64,
                "memory": 512,
                "essential": true,
                "portMappings": [
        {
          "protocol": "tcp",
          "containerPort": 8000,
          "hostPort": 0
        }
      ]
              }
            ],
            "family": "$task_definition_name"
          }

"@ | out-file c:\work\scripts\container_definition_$($image_name)_endian.json -encoding utf8

Get-Content c:\work\scripts\container_definition_$($image_name)_endian.json | Set-Content -Encoding utf8 c:\work\scripts\container_definition_$($image_name).json

$MyFile = Get-Content c:\work\scripts\container_definition_$($image_name)_endian.json
$Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False
[System.IO.File]::WriteAllLines("c:\work\scripts\container_definition_$($image_name).json", $MyFile, $Utf8NoBomEncoding)


Invoke-Expression -Command "aws ecs register-task-definition --cli-input-json file://c:\work\scripts\container_definition_$($image_name).json --region $region"

Invoke-Expression -Command "aws ecs update-service --cluster $cluster_name --service $service_name  --task-definition arn:aws:ecs:$($region):$($aws_account_number):task-definition/$($task_definition_name) --region $region"

Invoke-Expression -Command "aws ecs deregister-task-definition --task-definition $old_task_definition --region $region"
