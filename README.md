This provide a basic frame work on creating EC2 instance with terraform.  All you need is to update the vars.env file with appropriate values of your AWS accounts such as AMI, VPC, SG. 
* vars.env - Update this file before running gen-vars.sh script.
* gen-vars.sh - It generates backend.tf, vars.tf, and userdata.sh files.
* backend.tf - This file is created by gen-vars.sh.  It specifes S3 bucket/filename to store the remote state file.
* userdata.sh - This file is created by gen-vars.sh. This script is for EC2 to execute after the EC2 is up.   
* Note - userdata.sh is not stored/saved in the image.  it is part of the Launch Configuration (LC)   
* main.tf - this is the main terraform template file.   
* vars.tf - this file created by gen-vars.sh  You need to review this before run "terraform plan|apply"   
   
NOTEs:   
* Always run terraform plan to review the changes you made before running terraform apply.  Terraform apply may terminate the running instance and start a new instance with your changes.  
  
* Always store state file to remote storage (such as S3).  if you delete the state file, terraform doesn't know the current state of your EC2 instance, it will try to create a new instance.   

* You should not make change to the EC2 manually with CLI, or from console.  
* gen-vars.sh requires gomplate.  To Install gomplate curl -o /usr/local/bin/gomplate -sSL https://github.com/hairyhenderson/gomplate/releases/download/v3.5.0/gomplate_linux-amd64; chmod 755 /usr/local/bin/gomplate
#  end   #
