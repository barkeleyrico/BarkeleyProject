resource "aws_security_group" "eks_node_group_sg" {
  name        = "eks-node-group-sg"
  description = "Security group for EKS node group"
  vpc_id      = aws_vpc.barkeley.id

  # # Allow communication to/from the Kubernetes API server
  # ingress {
  #   from_port   = 443
  #   to_port     = 443
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"] # Restrict to specific IPs or ranges as needed
  # }

  # # Allow kubelet to communicate with the control plane
  # ingress {
  #   from_port   = 10250
  #   to_port     = 10250
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"] # Restrict to specific IPs or ranges as needed
  # }

  # Allow NodePort services
  ingress {
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Restrict to specific IPs or ranges as needed
  }

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Restrict to specific IPs or ranges as needed
  }

  # Allow DNS resolution within the cluster
  egress {
    from_port   = 53
    to_port     = 53
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Adjust as needed for DNS traffic
  }

  egress {
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"] # Adjust as needed for DNS traffic
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
