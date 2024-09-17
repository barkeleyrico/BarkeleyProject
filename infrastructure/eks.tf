resource "aws_eks_cluster" "eks_cluster" {
  name     = "barkeley-cluster"
  role_arn = aws_iam_role.eks.arn

  vpc_config {
    subnet_ids = [for subnet in aws_subnet.public_subnet : subnet.id]

  }
}


# resource "aws_eks_node_group" "eks_node_group" {
#   cluster_name    = aws_eks_cluster.eks_cluster.name
#   node_group_name = "barkeley-node-group"
#   node_role_arn   = aws_iam_role.node.arn
#   subnet_ids = [
#     for subnet in values(aws_subnet.public_subnet) : subnet.id
#   ]

#   launch_template {
#     name    = aws_launch_template.eks_node_lt.name
#     version = aws_launch_template.eks_node_lt.latest_version
#   }

#   #instance_types = ["t3.medium"] 

#   scaling_config {
#     desired_size = 1
#     max_size     = 3
#     min_size     = 1
#   }

#   depends_on = [
#     aws_eks_cluster.eks_cluster
#   ]
# }

resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "barkeley-node-group"
  node_role_arn   = aws_iam_role.node.arn
  subnet_ids      = [for subnet in aws_subnet.public_subnet : subnet.id]

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  instance_types = ["t3.small"]

  depends_on = [
    aws_eks_cluster.eks_cluster
  ]
}

# resource "aws_launch_template" "eks_node_lt" {
#   name = "eks-node-launch-template"

#   instance_type = "t3.medium" # Adjust as needed
#   #ami_id         = "ami-xxxxxxxx" # Ensure this is the correct EKS-optimized AMI or compatible AMI

#   vpc_security_group_ids = [aws_security_group.eks_node_group_sg.id]

#   iam_instance_profile {
#     name = aws_iam_instance_profile.eks_node_instance_profile.name
#   }

#   tag_specifications {
#     resource_type = "instance"

#     tags = {
#       Name = "eks-node-instance"
#     }
#   }

#   user_data = base64encode(<<EOF
# #!/bin/bash
# /etc/eks/bootstrap.sh barkeley-cluster
# EOF
#   )
# }

# resource "aws_launch_template" "eks_node_lt" {
#   name = "eks-node-launch-template"

#   instance_type = "t3.medium" # Change this to your desired instance type

#   vpc_security_group_ids = [aws_security_group.eks_node_group_sg.id]

#   tag_specifications {
#     resource_type = "instance"

#     tags = {
#       Name = "eks-node-instance"
#     }
#   }
# }
