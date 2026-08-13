output "policy_arns" {
  value = { for k, m in module.policies : k => m.policy_arn }
}