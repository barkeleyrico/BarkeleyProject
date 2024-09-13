# EKS Cluster
# resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSClusterPolicy" {
#   role       = "AWSServiceRoleForAmazonEKS"
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
# }

resource "aws_eks_cluster" "eks_cluster" {
  name     = "barkeley-cluster"
  role_arn = "arn:aws:iam::266735822117:role/aws-service-role/eks.amazonaws.com/AWSServiceRoleForAmazonEKS"

  vpc_config {
    subnet_ids = [
      for subnet in values(aws_subnet.public_subnet) : subnet.id
    ]
  }
}

resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "barkeley-node-group"
  node_role_arn   = "arn:aws:iam::266735822117:role/eks-node-role"
  subnet_ids = [
    for subnet in values(aws_subnet.public_subnet) : subnet.id
  ]

  scaling_config {
    desired_size = 1
    max_size     = 3
    min_size     = 1
  }

  depends_on = [
    aws_eks_cluster.eks_cluster
  ]
}