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

#resource "aws_security_group" "ingress_api" {
#  name        = "ingress-api"
#  description = "Allow ingress to API"
#  vpc_id      = aws_vpc.app_vpc.id
#
#  ingress {
#    from_port   = 3000
#    to_port     = 3000
#    protocol    = "TCP"
#    cidr_blocks = ["0.0.0.0/0"]
#  }
#}