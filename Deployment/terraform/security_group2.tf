#create load balancer for api-server load balancer
resource "aws_security_group" "api-elb-k8s-local" {
  name = "api-elb-${var.cluster_name}.k8s.local"
  vpc_id = aws_vpc.my_custom_vpc.id
  description = "security group for api elb"

  ingress {
    description      = "API port"
    from_port        = 6443
    to_port          = 6443
    protocol         = "tcp"
    cidr_blocks      = [var.general_internet_ip]
  }

  ingress {
    from_port        = 3
    to_port          = 4
    protocol         = "icmp"
    cidr_blocks      = [var.general_internet_ip]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks = [var.general_internet_ip]
  }

  tags = {
    Name = "api-elb-${var.cluster_name}.k8s.local"
    kubernetesCluster = "${var.cluster_name}.k8s.local"
  }
}

#create security group for bastion node
resource "aws_security_group" "bastion_node" {
  name        = "bastion_node"
  description = "allow required traffic to bastion node"
  vpc_id      = aws_vpc.my_custom_vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.general_internet_ip]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks = [var.general_internet_ip]
  }

  tags = {
    Name = "bastion_node"
  }
}

#create security group for worker node
resource "aws_security_group" "worker_node" {
  name        = "k8s_workers_${var.cluster_name}"
  description = "allow required traffic to worker node"
  vpc_id      = aws_vpc.my_custom_vpc.id

  ingress {
    description = "SSH"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [aws_vpc.my_custom_vpc.cidr_block]
  }

  ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [aws_vpc.my_custom_vpc.cidr_block]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks = [var.general_internet_ip]
  }

  tags = {
    Name = "${var.cluster_name}_nodes"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

#create security group for master node
resource "aws_security_group" "master_node" {
  name        = "k8s_masters_${var.cluster_name}"
  description = "allow required traffic to master node"
  vpc_id      = aws_vpc.my_custom_vpc.id

  tags = {
    Name = "${var.cluster_name}_nodes"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

resource "aws_security_group_rule" "traffic_from_lb" {
  type = "ingress"
  description = "allow api traffic from load balancer"
  from_port = 6443
  to_port = 6443
  protocol = "tcp"
  source_security_group_id = aws_security_group.api-elb-k8s-local.id
  security_group_id = aws_security_group.master_node.id
}

resource "aws_security_group_rule" "workers_to_master" {
  type = "ingress"
  description = "allow traffic from workers to master"
  from_port = 0
  to_port = 0
  protocol = "-1"
  source_security_group_id = aws_security_group.worker_node.id
  security_group_id = aws_security_group.master_node.id
}

resource "aws_security_group_rule" "bastion_to_master" {
  type = "ingress"
  description = "allow traffic from bastion node to master"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  source_security_group_id = aws_security_group.bastion_node.id
  security_group_id = aws_security_group.master_node.id
}

resource "aws_security_group_rule" "masters_egress" {
  type = "egress"
  description = "allow traffic from workers to master"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = [var.general_internet_ip]
  security_group_id = aws_security_group.master_node.id
}
