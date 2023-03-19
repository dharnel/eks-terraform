# EKS Cluster
resource "aws_eks_cluster" "eks_cluster" {
  name     = "${var.cluster_name}-cluster"
  role_arn = aws_iam_role.cluster.arn
  version  = "1.25"

  vpc_config {
    security_group_ids      = [aws_security_group.master_node.id , aws_security_group.worker_node.id, aws_security_group.eks_cluster.id, aws_security_group.eks_nodes.id]
    subnet_ids              = [aws_subnet.public_az1.id,aws_subnet.utility.id]
    endpoint_private_access = true
    endpoint_public_access  = true
    public_access_cidrs     = [var.general_internet_ip]
  }

  tags = {
    Name = "${var.cluster_name}"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy
  ]
}

#create eks cluster roles
resource "aws_iam_role" "cluster" {
  name = "${var.cluster_name}-Cluster-Role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
       
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster.name
}

# EKS Cluster Security Group
resource "aws_security_group" "eks_cluster" {
  name        = "${var.cluster_name}-sg"
  description = "Cluster communication with worker nodes"
  vpc_id      = aws_vpc.my_custom_vpc.id

  tags = {
    Name = "${var.cluster_name}-sg"
  }
}

resource "aws_security_group_rule" "cluster_inbound" {
  description              = "Allow worker nodes to communicate with the cluster API Server"
  from_port                = 6443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_cluster.id
  source_security_group_id = aws_security_group.eks_nodes.id
  to_port                  = 6443
  type                     = "ingress"
}

resource "aws_security_group_rule" "cluster_outbound" {
  description              = "Allow cluster API Server to communicate with the worker nodes"
  from_port                = 1024
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_cluster.id
  source_security_group_id = aws_security_group.eks_nodes.id
  to_port                  = 65535
  type                     = "egress"
}

