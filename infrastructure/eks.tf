

resource "aws_eks_cluster" "eks_cluster" {
  name     = "barkeley-cluster"
  role_arn = aws_iam_role.eks.arn

  vpc_config {
    subnet_ids = [
      for subnet in values(aws_subnet.public_subnet) : subnet.id
    ]
  }
}

resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "barkeley-node-group"
  node_role_arn   = aws_iam_role.node.arn
  subnet_ids = [
    for subnet in values(aws_subnet.public_subnet) : subnet.id
  ]

  instance_types = ["t3.medium"] 

  scaling_config {
    desired_size = 1
    max_size     = 3
    min_size     = 1
  }

    #node_security_group_ids = aws_security_group.eks_node_group_sg.id

  depends_on = [
    aws_eks_cluster.eks_cluster
  ]
}