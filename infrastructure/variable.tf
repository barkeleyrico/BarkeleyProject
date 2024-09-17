variable "public_subnets" {
  description = "List of public subnets with AZ and CIDR"
  type = list(object({
    az         = string
    cidr_block = string
  }))
  default = [
    {
      az         = "ap-southeast-1a"
      cidr_block = "10.0.10.0/24"
    },
    {
      az         = "ap-southeast-1b"
      cidr_block = "10.0.20.0/24"
    },
    {
      az         = "ap-southeast-1c"
      cidr_block = "10.0.30.0/24"
    }
  ]
}

# variable "private_subnets" {
#   description = "List of public subnets with AZ and CIDR"
#   type = list(object({
#     az         = string
#     cidr_block = string
#   }))
#   default = [
#     {
#       az         = "ap-southeast-1b"
#       cidr_block = "10.0.2.0/24"
#     },
#     {
#       az         = "ap-southeast-1c"
#       cidr_block = "10.0.3.0/24"
#     }
#   ]
# }

# variable "private_subnets" {
#   description = "List of public subnets with AZ and CIDR"
#   type = list(object({
#     az         = string
#     cidr_block = string
#   }))
#   default = [
#     {
#       az         = "ap-southeast-1a"
#       cidr_block = "10.0.1.0/24"
#     },
#     {
#       az         = "ap-southeast-1b"
#       cidr_block = "10.0.2.0/24"
#     },
#     {
#       az         = "ap-southeast-1c"
#       cidr_block = "10.0.3.0/24"
#     }
#   ]
# }