resource "aws_iam_role" "loadbalancer_controller" {
  name                = "loadbalancer-controller-${local.cluster_name}"
  assume_role_policy  = data.aws_iam_policy_document.federated.json
  managed_policy_arns = ["arn:aws:iam::602039007070:policy/AWSLoadBalancerControllerIAMPolicy"]  # TBD: replace with output from stage1
}

data "aws_iam_policy_document" "federated" {
  statement {
    actions = [
      "sts:AssumeRoleWithWebIdentity",
    ]
    condition {
      test     = "StringEquals"
      variable = "${replace(module.eks_cluster.cluster_oidc_issuer_url, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "${replace(module.eks_cluster.cluster_oidc_issuer_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:aws-load-balancer-controller"]
    }
    effect = "Allow"
    principals {
      type        = "Federated"
      identifiers = [ module.eks_cluster.oidc_provider_arn ]
    }
  }
}
