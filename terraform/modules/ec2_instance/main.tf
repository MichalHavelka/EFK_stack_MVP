data "aws_ami" "ami_debian" {
  most_recent = true

  filter {
    name   = "name"
    values = var.filter_name
  }

  filter {
    name   = "architecture"
    values = var.filter_architecture
  }

  filter {
    name   = "virtualization-type"
    values = var.filter_virt-type
  }

  owners = var.owners
}

resource "aws_instance" "this" {
  ami                         = data.aws_ami.ami_debian.id
  instance_type               = var.instance_type
  vpc_security_group_ids      = var.vpc_security_group_ids
  subnet_id                   = var.subnet_id
  associate_public_ip_address = var.associate_public_ip_address
  key_name                    = var.key_name

  root_block_device {
    volume_type = var.volume_type
    volume_size = var.volume_size
  }

  tags = var.tags
}
