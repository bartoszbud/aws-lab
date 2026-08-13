locals {
  iam_groups = {
    developers = {
      group_name = "Developers"
      policies   = ["developers_ec2_access", "developers_s3_access"]
    }
  }
}

module "groups" {
  for_each = local.iam_groups
  source   = "../../modules/iam/groups"

  group_name  = each.value.group_name
  policy_arns = { for k in each.value.policies : k => module.policies[k].policy_arn }
}