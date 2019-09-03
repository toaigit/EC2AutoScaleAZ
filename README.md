This provide a basic frame work on creating EC2 instance with terraform.   
* vars.env - Update this file before running gen-vars.sh script
* gen-vars.sh - generate backend.tf and vars.tf file
* backend.tf - specify S3 bucket/filename to store the remote state file.  
* userdata.sh - script for EC2 to execute after the EC2 is up.   
* Note - this only executed when the instance is created and not when you start/restart instance.  Userdata.sh is not stored/saved in the image.  it is part of the Launch Configuration (LC)   
* main.tf - this is the main terraform template file.   
* vars.tf - this defines logical name (used in the main.tf). it is the mapping between logical name and VPC/EC2 ids.  For example, you define subnet-zonea --> subnet-29ac29f.  You need to review this before run "terraform plan|apply"   
   
NOTEs:   
* always run terraform plan to review the changes you made before running terraform apply.  Terraform apply may terminate the running instance and start a new instance with your changes.  
  
* always store state file to remote storage (such as S3).  if you delete the state file, terraform doesn't know the current state of your EC2 instance, it will try to create a new instance.   

*   you should not make change to the EC2 manually with CLI, or from console.  
* Install gomplate curl -o /usr/local/bin/gomplate -sSL https://github.com/hairyhenderson/gomplate/releases/download/v3.5.0/gomplate_linux-amd64; chmod 755 /usr/local/bin/gomplate
#  end   #
