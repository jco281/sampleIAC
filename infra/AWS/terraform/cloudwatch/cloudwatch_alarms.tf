provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  tags = {
    Name = "WebServer"
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu_utilization_high" {
  alarm_name          = "high-cpu-utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"

  dimensions = {
    InstanceId = aws_instance.web.id
  }

  alarm_description = "This metric monitors high CPU utilization"
}

resource "aws_cloudwatch_metric_alarm" "disk_write_ops_high" {
  alarm_name          = "high-disk-write-ops"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "DiskWriteOps"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Sum"
  threshold           = "5000"

  dimensions = {
    InstanceId = aws_instance.web.id
  }

  alarm_description = "This metric monitors high disk write operations"
}

resource "aws_cloudwatch_metric_alarm" "status_check_failed" {
  alarm_name          = "status-check-failed"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "StatusCheckFailed"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Maximum"
  threshold           = "1"

  dimensions = {
    InstanceId = aws_instance.web.id
  }

  alarm_description = "This metric monitors instance status check failures"
}
