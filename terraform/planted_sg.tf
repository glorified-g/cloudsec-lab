# KAN-55 planted finding. Do not merge. Do not terraform apply.
resource "aws_security_group" "planted_ssh" {
  name        = "${var.name}-planted-ssh"
  description = "Planted: SSH open to the world"
  vpc_id      = aws_vpc.lab.id

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
