variable "region" {
  description = "AWS infra region"
  type        = string
  default     = "eu-central-1"
}

variable "app" {
  description = "Name of the project/application this infra is used for"
  type        = string
  default     = "jamf_efk_mvp"
}

variable "owner" {
  description = "Owner of the project/application"
  type        = string
  default     = "michal"
}

variable "env" {
  description = "project/application environment"
  type        = string
  default     = "test"
}

variable "location" {
  description = "Location short name"
  type        = string
  default     = "euc1"
}

variable "availability-zone" {
  description = "availability zone of all resources"
  type        = string
  default     = "eu-central-1a"

}

variable "public-key" {
  description = "pub key used to ssh into EC2 instances"
  type        = string
  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICoVu/nqU3aCVgeHviUANSb1AASLjkkITA+Pi0DU4Tvd"
}

variable "vpc-cidr" {
  description = "CIDR of VPC used by all EC2 instances"
  type        = string
  default     = "192.168.0.0/16"
}

variable "subnet-cidr" {
  description = "CIDR of subnet used by all EC2 instances"
  type        = string
  default     = "192.168.10.0/24"
}
