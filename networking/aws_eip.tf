resource "aws_eip" "nleip1" {
  vpc = true
  depends_on = [aws_internet_gateway.nlpgw]
}

resource "aws_eip" "nleip2" {
  vpc = true
  depends_on = [aws_internet_gateway.nlpgw]
}