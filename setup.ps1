$script_path = "C:\work\docker\scripts"
If(!(test-path $script_path))
{
      New-Item -ItemType Directory -Force -Path $script_path
}


$content_path = "C:\work\docker\content"
If(!(test-path $content_path))
{
      New-Item -ItemType Directory -Force -Path $content_path
}

$script = "update-service.ps1"
copy-item -path $script -destination $script_path

$dockerfile = "Dockerfile"
copy-item -path $dockerfile -destination C:\work\docker\
