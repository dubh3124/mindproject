module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "test-eks-cluster"
  cluster_version = "1.30"

  cluster_endpoint_public_access  = true

  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
  }
  cloudwatch_log_group_class = "STANDARD"
  cloudwatch_log_group_tags = {
    environment = var.environment
    project     = var.project_alias
  }

  vpc_id                   = data.terraform_remote_state.nlpnetwork.outputs.vpcid
  subnet_ids               = data.terraform_remote_state.nlpnetwork.outputs.private-subnets
#   control_plane_subnet_ids = ["subnet-xyzde987", "subnet-slkjf456", "subnet-qeiru789"]

#   # EKS Managed Node Group(s)
#   eks_managed_node_group_defaults = {
#     instance_types = ["m6i.large", "m5.large", "m5n.large", "m5zn.large"]
#   }

  eks_managed_node_groups = {
    example = {
      instance_types = ["t3.small"]
      capacity_type  = "SPOT"

      min_size     = 2
      max_size     = 2
      desired_size = 2

      iam_role_additional_policies = {
        alb = aws_iam_policy.nodegroup-alb.arn
        eks = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"

      }


    }
  }

  # Cluster access entry
  # To add the current caller identity as an administrator
  enable_cluster_creator_admin_permissions = true

#   access_entries = {
#     # One access entry with a policy associated
#     example = {
#       kubernetes_groups = []
#       principal_arn     = "arn:aws:iam::123456789012:role/something"

#       policy_associations = {
#         example = {
#           policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy"
#           access_scope = {
#             namespaces = ["default"]
#             type       = "namespace"
#           }
#         }
#       }
#     }
#   }

  tags = {
    environment = var.environment
    Terraform   = "true"
  }
}

resource "aws_iam_policy" "nodegroup-alb" {
    name        = "nodegroup-alb"
    description = "Policy for ALB access"
    policy      = data.aws_iam_policy_document.example.json
  
}
data "aws_iam_policy_document" "example" {
  statement {
    actions = [
      "elasticloadbalancing:DescribeLoadBalancers",
      "elasticloadbalancing:DescribeTargetGroups",
      "elasticloadbalancing:DescribeTargetHealth",
      "elasticloadbalancing:CreateListener",
      "elasticloadbalancing:CreateRule",
      "elasticloadbalancing:CreateTargetGroup",
      "elasticloadbalancing:DeleteListener",
      "elasticloadbalancing:DeleteRule",
      "elasticloadbalancing:DeleteTargetGroup",
      "elasticloadbalancing:ModifyListener",
      "elasticloadbalancing:ModifyRule",
      "elasticloadbalancing:ModifyTargetGroup",
      "elasticloadbalancing:ModifyTargetGroupAttributes",
      "elasticloadbalancing:RegisterTargets",
      "elasticloadbalancing:DeregisterTargets",
      "elasticloadbalancing:*",
      "ec2:DescribeInstances",
      "ec2:DescribeSubnets",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeVpcs",
      "ec2:Describe*"
    ]

    resources = ["*"]

    effect = "Allow"
  }
}