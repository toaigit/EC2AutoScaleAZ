Additional options you can added to the main.tf file
* iam_instance_profile = "{$var.IAM_ROLE}"  --> in aws_launch_configuration section
* if you need Elastic IP for your instance, you can create the eip.tf file as follows
```
resource "aws_eip" "my_eip" {
  vpc      = true
  lifecycle {
    prevent_destroy = false
  }
}
output "myeip_output" {
   value = "${aws_eip.my_eip.id}"
}

output "myeip_iaddr_output" {
  value = "${aws_eip.my_eip.public_ip}"
}   
```
#  end   #
