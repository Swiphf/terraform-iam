variable "aws_region" {
  type = string
}

variable "role_name" {
  type = string
}

variable "assume_role_policy" {
  type = string
}

variable "policy_name" {
  type = string
}

variable "policy_description" {
  type = string
}

variable "policy_statements" {
  type = list(object({
    effect    = string
    actions   = list(string)
    resources = list(string)
  }))
}
