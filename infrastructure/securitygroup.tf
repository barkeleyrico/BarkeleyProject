resource "aws_security_group" "eks_node_group_sg" {
  name        = "eks-node-group-sg"
  description = "Security group for EKS node group"
  vpc_id      = aws_vpc.barkeley.id

  ingress {
    from_port   = 30001
    to_port     = 30001
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