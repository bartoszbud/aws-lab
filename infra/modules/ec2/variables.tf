variable "environment" {
  description = "Environment name"
  type        = string
}

variable "purpose" {
  description = "Instance purpose - web, queue etc."
  type        = string
}

variable "firewall_rules" {
  description = "Map of firewall rules"
  type = map(object({
    protocol    = optional(string, "tcp")
    port        = number
    source_ips  = list(string)
    description = string
  }))

  /*validation {
    condition     = alltrue([for i in var.firewall_rules : i.port >= 0 && i.port <= 65535])
    error_message = "Port has to be number from 0 to 65535"
  }

  validation {
    condition     = alltrue([for i in var.firewall_rules : alltrue([for cidr in i.source_ips : can(cidrhost(cidr, 0))])])
    error_message = "Incorrect value, CIDR has to be in correct format, e.g., 10.0.0.0/16"
  }*/
}