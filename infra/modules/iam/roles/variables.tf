variable "role_name" {
  description = "Role name"
  type        = string
}

variable "assume_role_policy" {
  description = "JSON trust policy (who can assume the role)"
  type        = string
}

variable "tags" {
  description = "Tags"
  type        = map(string)
  default     = {}
}

variable "managed_policy_arns" {
  type        = list(string)
  default     = []
  description = "A list of ARNs of managed policies to attach to the role"
}

variable "inline_policies" {
  type        = map(string) # name => JSON policy
  default     = {}
  description = "Inline policy as a map of name -> JSON"
}