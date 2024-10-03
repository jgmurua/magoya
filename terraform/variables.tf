variable "vpc_name" {
  description = "Name of VPC where cluster will be created on"
  type        = string
  default     = "eks-simple-vpc"
}
variable "region" {
  description = "AWS Region where cluster will be created on"
  type        = string
  default     = "us-east-1"
}
variable "vpc_cidr" {
  description = "The Cidr of VPC where cluster will be created on, the default value is \"10.0.0.0/16\""
  type        = string
  default     = "10.0.0.0/16"
}
variable "cluster_name" {
  description = "Name of the EKS Cluster. Must be between 1-100 characters in length. Must begin with an alphanumeric character, and must only contain alphanumeric characters, dashes and underscores (^[0-9A-Za-z][A-Za-z0-9-_]+$)."
  type        = string
  default     = "eks-simple"
}

variable "desired_size" {
  description = "Desired size of the worker node"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum size of the worker node"
  type        = number
  default     = 2
}
variable "min_size" {
  description = "Minimum size of the worker node"
  type        = number
  default     = 1
}
variable "instance_types" {
  description = "List of instance types associated with the EKS Node Group. the default vaule is [\"t3.medium\"]. Terraform will only perform drift detection if a configuration value is provided."
  type        = list(string)
  default     = ["t3.medium"]

}


variable "vpc_azs" {
  description = "List of Availability Zones where the EKS Node Group will create worker nodes. The default value is [\"us-east-1a\", \"us-east-1b\", \"us-east-1c\"]."
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "vpc_private_subnets" {
  description = "List of private subnets in your custom VPC"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "vpc_public_subnets" {
  description = "List of public subnets in your custom VPC"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "vpc_enable_nat_gateway" {
  description = "Should be true if you want to provision NAT Gateways for each of your private networks"
  type        = bool
  default     = true
}

variable "vpc_single_nat_gateway" {
  description = "Should be true if you want to provision a single shared NAT Gateway across all of your private networks"
  type        = bool
  default     = true
}

variable "vpc_enable_vpn_gateway" {
  description = "Should be true if you want to create a new VPN Gateway resource and attach it to the VPC"
  type        = bool
  default     = false
}

variable "vpc_enable_dns_hostnames" {
  description = "Should be true to enable DNS hostnames in the VPC"
  type        = bool
  default     = true
}

variable "vpc_enable_dns_support" {
  description = "Should be true to enable DNS support in the VPC"
  type        = bool
  default     = true
}

variable "cluster_version" {
  description = "The desired Kubernetes master version."
  type        = string
  default     = "1.30"
}
variable "domain_name" {
  description = "The domain name"
  type        = string
  default     = "jgmurua.com.ar"
}
variable "vpc_database_subnets" {
  description = "List of database subnets in your custom VPC"
  type        = list(string)
  default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

variable "create_cert" {
  description = "Should be true if you want to create a certificate"
  type        = bool
  default     = true
}


variable "create_public_spot_node_group" {
  description = "Should be true if you want to create a public spot node group"
  type        = bool
  default     = false
}