resource "aws_security_group" "http" {
  name        = "http"
  description = "HTTP traffic"
  vpc_id      = data.terraform_remote_state.nlpnetwork.outputs.vpcid

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "egress_all" {
  name        = "egress-all"
  description = "Allow all outbound traffic"
  vpc_id      = data.terraform_remote_state.nlpnetwork.outputs.vpcid

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ingress_api" {
  name        = "ingress-nlpappbackend-${local.full_name}"
  description = "Allow ingress to API"
  vpc_id      = data.terraform_remote_state.nlpnetwork.outputs.vpcid

  ingress {
    from_port   = local.api_port
    to_port     = local.api_port
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
}