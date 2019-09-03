resource "aws_autoscaling_group" "ServerGroup" {
  name_prefix               = "${var.ASG_NAME}"
  max_size                  = "${var.MAX_SIZE}"
  min_size                  = "${var.MIN_SIZE}"
  desired_capacity          = "${var.ASG_DESIRE}"
  health_check_grace_period = "${var.HEALTH_CHECK_GRACE_PERIOD}"
  vpc_zone_identifier     = ["${var.SUBNET1}","${var.SUBNET2}","${var.SUBNET3}"]
  launch_configuration    = "${aws_launch_configuration.LaunchConfig.name}"
  tags = [
      { 
      key = "Name" 
      value = "${var.SERVERNAME}" 
      propagate_at_launch = true
      },
      {
      key = "Creator"
      value = "${var.CREATOR}"
      propagate_at_launch = true
      }
  ]
}

resource "aws_launch_configuration" "LaunchConfig" {
  name_prefix   = "${var.LC_NAME}"
  image_id      = "${var.IMAGE_ID}"
  instance_type = "${var.INSTANCE_TYPE}"
  key_name      = "${var.KEY_NAME}"
  security_groups = ["${var.SG}"]
  associate_public_ip_address = true
  root_block_device {
    volume_type = "${var.VOLUME_TYPE}"
    volume_size = "${var.VOLUME_SIZE}"
    delete_on_termination = "${var.DELETE_ON_TERMINATION}"
  }
  user_data     = "${file("userdata.sh")}"
}
