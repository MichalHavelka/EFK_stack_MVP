resource "aws_security_group" "sg" {
  name   = "sg1-${local.stack}"
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    local.default_tags,
    { Name = "sg1-${local.stack}" }
  )
}

resource "aws_security_group_rule" "sec_group_allow_all" {
  type          = "ingress"
  from_port     = 0
  to_port       = 0
  protocol      = "-1"
  security_group_id = aws_security_group.sg.id
  source_security_group_id = aws_security_group.sg.id
}

resource "aws_security_group_rule" "sec_group_allow_egress" {
  type          = "egress"
  from_port     = 0
  to_port       = 0
  protocol      = "-1"
  security_group_id = aws_security_group.sg.id
  cidr_blocks    = ["0.0.0.0/0"]
}

