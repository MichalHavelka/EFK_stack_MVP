locals {
  stack = "${var.app}-${var.env}-${var.location}"

  default_tags = {
    environment = var.env
    owner       = var.owner
    project     = var.app
  }
}

resource "aws_key_pair" "kp_admin" {
  key_name   = "admin-keypair"
  public_key = var.public-key

  tags = merge(
    local.default_tags,
    { Name = "kp_admin-${local.stack}" }
  )
}

module "ec2_instance_1" {
  source                 = "./modules/ec2_instance"
  vpc_security_group_ids = [aws_security_group.sg.id]
  subnet_id              = aws_subnet.subnet.id
  key_name               = aws_key_pair.kp_admin.id
  user_data              = templatefile("./puppet/puppet_master.sh", {})
  private_ip             = "192.168.10.40"
  tags = merge(
    local.default_tags,
    { Name = "ec2_instance_1-${local.stack}" }
  )
}
module "ec2_instance_2" {
  source                 = "./modules/ec2_instance"
  vpc_security_group_ids = [aws_security_group.sg.id]
  subnet_id              = aws_subnet.subnet.id
  key_name               = aws_key_pair.kp_admin.id
  user_data              = templatefile("./puppet/puppet_agent.sh", {master_ip = module.ec2_instance_1.private_ip})
  private_ip             = "192.168.10.41"
  tags = merge(
    local.default_tags,
    { Name = "ec2_instance_2-${local.stack}" }
  )
}
module "ec2_instance_3" {
  source                 = "./modules/ec2_instance"
  vpc_security_group_ids = [aws_security_group.sg.id]
  subnet_id              = aws_subnet.subnet.id
  key_name               = aws_key_pair.kp_admin.id
  user_data              = templatefile("./puppet/puppet_agent.sh", {master_ip = module.ec2_instance_1.private_ip})
  private_ip             = "192.168.10.42"
  tags = merge(
    local.default_tags,
    { Name = "ec2_instance_3-${local.stack}"}
  )
}
