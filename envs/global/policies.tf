locals {
  iam_policies = {
    developers_ec2_access = {
      policy_name        = "DevelopersEC2Access"
      policy_description = "Policy for developers to access EC2 instances"
      policy_json        = data.aws_iam_policy_document.developers_ec2_access.json
    },
    developers_s3_access = {
      policy_name        = "DevelopersS3Access"
      policy_description = "Policy for developers to access S3 buckets"
      policy_json        = data.aws_iam_policy_document.developers_s3_access.json
    }
  }
}

module "policies" {
  for_each = local.iam_policies
  source   = "../../infra/modules/iam/policies"

  policy_name        = each.value.policy_name
  policy_description = each.value.policy_description
  policy_json        = each.value.policy_json
}

#policies
data "aws_iam_policy_document" "developers_ec2_access" {
  statement {
    sid       = "AllowEC2RunInstances"
    effect    = "Allow"
    actions   = ["ec2:RunInstances"]
    resources = ["arn:aws:ec2:*:*:instance/*", "arn:aws:ec2:*:*:volume/*"]
    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/Environment"
      values   = ["Dev"]
    }
    condition {
      test     = "ForAllValues:StringEquals"
      variable = "aws:TagKeys"
      values   = ["Environment"]
    }
  }
}

data "aws_iam_policy_document" "developers_s3_access" {
  statement {
    sid       = "AllowS3GetObject"
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::developers-bucket/*"]
    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/Environment"
      values   = ["Dev"]
    }
    condition {
      test     = "ForAllValues:StringEquals"
      variable = "aws:TagKeys"
      values   = ["Environment"]
    }
  }
}