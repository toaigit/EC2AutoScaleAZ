### Overview
This provides a basic frame work on creating EC2 instance with terraform.  All you need is to update the vars.env file with appropriate values of your AWS accounts such as AMI, VPC, SG. 
* vars.env - Update this file before running gen-vars.sh script.
* gen-vars.sh - It generates backend.tf, vars.tf, and userdata.sh files based on the vars.env values.
* backend.tf - This file is created by gen-vars.sh.  It specifes S3 bucket/filename to store the remote state file.
* userdata.sh - This file is created by gen-vars.sh. It is for EC2 to execute after the EC2 is up.   
* Note - userdata.sh is not stored/saved in the image.  it is part of the Launch Configuration (LC)   
* main.tf - this is the main terraform template file.   
* vars.tf - this file created by gen-vars.sh  You need to review this before run "terraform plan|apply"   
* NOTES.md - this file give you additional terraform syntax (if needed) for S3, SG, EIP, ELB, etc   
NOTEs:   
* Always run terraform plan and review the changes before running terraform apply.  Terraform apply may terminate the running instance and start a new instance with your changes.  
  
* Always store state file to remote storage (such as S3).  if you delete the state file, terraform doesn't know the current state of your EC2 instance, it will try to create a new instance.   

* You should not make change to the EC2 manually with CLI, or from console.  
* gen-vars.sh requires gomplate.  To Install gomplate curl -o /usr/local/bin/gomplate -sSL https://github.com/hairyhenderson/gomplate/releases/download/v3.5.0/gomplate_linux-amd64; chmod 755 /usr/local/bin/gomplate

### Steps to create EC2
*  Update vars.env based on your AWS environment
*  Run ./gen-vars.sh (Making sure you have installed gomplate)
*  You should see backend.ft, userdata.sh, main.tf and vars.tf in the folder now.
*  Set AWS environment variabes AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_DEFAULT_REGION
*  Run terrafrom init, terraform plan, and terraform apply.
*  To save money, you may want to run terraform destroy.
#  end   #
