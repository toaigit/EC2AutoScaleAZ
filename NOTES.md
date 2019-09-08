Additional options you can added to the main.tf file
* iam_instance_profile = "{$var.IAM_ROLE}"  --> in aws_launch_configuration section
* If you need to create S3 bucket
```
resource "aws_s3_bucket" "toai-remotestate"  {
     bucket = "johndoe.statefile.domain"
     acl = "private"
     versioning {
          enabled = true
     }
     lifecycle {
          prevent_destroy = true
          }
     tags = {
       Name     = "My StateFile Bucket"
       Environment = "SandBox"
       }
}
```
* If you need to create a new security group.  Here is an example allow inbound ssh, 80, 443 from some servers.
```
resource "aws_security_group" "allow_ssh_ssl" {
  name        = "allow_ssh_ssl"
  description = "Allow TLS inbound traffic"
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["16.5.38.93/32","171.64.0.0/14"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["16.5.38.93/32","171.64.0.0/14"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["16.5.38.93/32","171.64.0.0/14"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "toai_ssh_http"
    Description = "Allow SSH HTTP from Campus and Home"
  }
}
```
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
* And add the following line in your userdata
```
/path/to/aws ec2 associate-address --instance-id $(curl http://169.254.169.254/latest/meta-data/instance-id) --allocation-id "${aws_eip.my_eip.id}" --allow-reassociation --region "${var.REGION}"
```

* if you need to add ELB for your instance, you can add the following lines in your main.tf file:
```
resource "aws_elb" "bastionELB" {
  name = "bastionELB"
  security_groups = ["${var.SG}"]
  subnets = ["${var.SUBNIET1}","${var.SUBNET2}","${var.SUBNET3}"]
  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    interval = 30
    target = "HTTP:${var.HTTP_SERVER_PORT}/"
  }
  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = "${var.HTTP_SERVER_PORT}"
    instance_protocol = "http"
  }
 listener {
    lb_port            = 443
    lb_protocol        = "https"
    instance_port      = "${var.HTTP_SERVER_PORT}"
    instance_protocol  = "http"
    ssl_certificate_id = "${var.SSL_CERT_ARN}"
  }
}

resource "aws_lb_cookie_stickiness_policy" "SSLstickiness" {
  name                     = "SSLsticky"
  load_balancer            = "${aws_elb.bastionELB.id}"
  lb_port                  = 443
  cookie_expiration_period = 600
}

resource "aws_lb_cookie_stickiness_policy" "HTTPstickiness" {
  name                     = "HTTPsticky"
  load_balancer            = "${aws_elb.bastionELB.id}"
  lb_port                  = 80
  cookie_expiration_period = 600
}

output "elb_dns_name" {
  value = "${aws_elb.bastionELB.dns_name}"
}

```
* And add the following line in your aws_autoscaling_group
```
load_balancers            = ["${aws_elb.bastionELB.name}"]
```
* List of AMI
```
aws ec2 describe-images --owner self --query 'Images[*][ImageId,Name]' --output text | sort -k2  (your own images)
aws ec2 describe-images --owner 379101102735 --query 'Images[*][ImageId,Name]' --output text | sort -k2 (Debian Images)
```
* List of Subnets and VPC
```
aws ec2  describe-vpcs --query 'Vpcs[*][VpcId,Tags[?Key==`Name`].Value[]]' --output=table  (List of VPCs)
aws ec2 describe-subnets --query 'Subnets[*][VpcId,SubnetId,AvailabilityZone]' --output table  (List of Subnets within VPCs)
```

* ARN resource name
```
VPC: arn:aws:ec2:REGION:AWSACCT:vpc/VPCID, or arn:aws:ec2:REGION:AWSACCT:vpc/*
SGR: arn:aws:ec2:REGION:AWSACCT:security-group/* , OR arn:aws:ec2:REGION:AWSACCT:security-group/sg-123abc123
VOL: arn:aws:ec2:REGION:AWSACCT:volume/*
SUB: arn:aws:ec2:REGION:AWSACCT:subnet/subnet-1a2b3c4d"
SECRET: arn:aws:secretsmanager:REGION:AWSACCT:secret:TestEnv/*"
```
#  end   #
