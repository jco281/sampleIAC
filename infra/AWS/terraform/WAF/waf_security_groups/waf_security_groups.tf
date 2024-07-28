provider "aws" {
  region = "us-west-2"
}

resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Allow HTTP and HTTPS traffic"
  vpc_id      = "vpc-123456"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-sg"
  }
}

resource "aws_waf_web_acl" "web_acl" {
  name        = "web-acl"
  metric_name = "webACL"

  default_action {
    type = "ALLOW"
  }

  rules {
    action {
      type = "BLOCK"
    }

    priority = 1
    type     = "REGULAR"
    rule_id  = aws_waf_rule.sql_injection_rule.id
  }
}

resource "aws_waf_rule" "sql_injection_rule" {
  name        = "sql-injection-rule"
  metric_name = "sqlInjectionRule"

  predicates {
    data_id = aws_waf_sql_injection_match_set.sql_injection_set.id
    negated = false
    type    = "SqlInjectionMatch"
  }
}

resource "aws_waf_sql_injection_match_set" "sql_injection_set" {
  name = "sqlInjectionMatchSet"

  sql_injection_match_tuples {
    field_to_match {
      type = "BODY"
    }

    text_transformation = "NONE"
  }
}
