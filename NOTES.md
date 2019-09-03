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
output "myeip_id" {
   value = "${aws_eip.my_eip.id}"
}

```
* Add the following line in your userdata
```
/path/to/aws ec2 associate-address --instance-id $(curl http://169.254.169.254/latest/meta-data/instance-id) --allocation-id "${aws_eip.my_eip.id}" --allow-reassociation --region "${var.REGION}"
```
#  end   #
