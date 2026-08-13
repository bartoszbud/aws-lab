variable "group_name" {
  description = "Group name"
  type        = string
}

variable "policy_arns" {
  description = "List of policy ARNs to attach to the group"
  type        = map(string)
}