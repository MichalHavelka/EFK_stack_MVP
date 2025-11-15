variable "ami" {
  description = "EC2 ami id"
  type        = string
  default     = "eu-central-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "m7i-flex.large"
}

variable "vpc_security_group_ids" {
  description = "Security group of vpc"
  type        = list(any)
  default     = []
}

variable "subnet_id" {
  description = "Subnet id"
  type        = string
  default     = ""
}

variable "associate_public_ip_address" {
  description = "Enable or disable association of public IP to EC2"
  type        = bool
  default     = true
}

variable "key_name" {
  description = "name of key-pair to ssh into EC2"
  type        = string
  default     = ""
}

variable "volume_type" {
  description = "gp2/gp3 EBS volume type"
  type        = string
  default     = "gp3"
}

variable "volume_size" {
  description = "size of EBS volume"
  type        = number
  default     = 20
}

variable "filter_name" {
  description = "ami name to filter"
  type        = list(any)
  default     = ["debian-13-amd64-*"]
}

variable "filter_architecture" {
  description = "list of architectures to filter"
  type        = list(any)
  default     = ["x86_64"]
}

variable "filter_virt-type" {
  description = "list of virtualization types to filter"
  type        = list(any)
  default     = ["hvm"]
}

variable "owners" {
  description = "list of ami owners"
  type        = list(any)
  default     = ["136693071363"]
}

variable "tags" {
  description = "map of aws tags"
  type        = map(string)
}


