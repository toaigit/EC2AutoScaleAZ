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
#  end   #
