# EC2 AMI images
data "aws_ssm_parameter" "amz2-ami-primary" {
  provider = aws.primary
  name     = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

# EC2 Primary-VPC Instance ssh keys
resource "aws_key_pair" "primary-key" {
  provider   = aws.primary
  key_name   = "udac"
  public_key = file(var.ssh_path)
}

# EC2 Primary-VPC Instance creation

# Instances in Primary-VPC public az-a
resource "aws_instance" "web-server-paz-a" {
  provider                    = aws.primary
  count                       = var.primary-web.count
  ami                         = data.aws_ssm_parameter.amz2-ami-primary.value
  instance_type               = var.primary-web.instance-type
  key_name                    = aws_key_pair.primary-key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.primary-web-tier.id]
  subnet_id                   = aws_subnet.primary-subnet-01.id
  user_data                   = file(var.primary-web.user_data_path)
  tags = merge(
    var.udc_default_tags,
    {
      Name = join("-", ["Udacity t2 - web-server", count.index + 1, "a"])
      Tier = "Web"
    }
  )
  root_block_device {
    volume_type = var.primary-web.storage-type
    volume_size = var.primary-web.storage-size
  }
}

# Instances in Primary-VPC public az-b
resource "aws_instance" "web-server-paz-b" {
  provider                    = aws.primary
  count                       = var.primary-web.count
  ami                         = data.aws_ssm_parameter.amz2-ami-primary.value
  instance_type               = var.primary-web.instance-type
  key_name                    = aws_key_pair.primary-key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.primary-web-tier.id]
  subnet_id                   = aws_subnet.primary-subnet-02.id
  user_data                   = file(var.primary-web.user_data_path)
  tags = merge(
    var.udc_default_tags,
    {
      Name = join("-", ["Udacity t2 - web-server", count.index + 1, "b"])
      Tier = "Web"
    }
  )
  root_block_device {
    volume_type = var.primary-web.storage-type
    volume_size = var.primary-web.storage-size
  }
}

# Instances in Primary-VPC private az-a
resource "aws_instance" "db-paz-a" {
  provider                    = aws.primary
  count                       = var.primary-db.count
  ami                         = data.aws_ssm_parameter.amz2-ami-primary.value
  instance_type               = var.primary-db.instance-type
  key_name                    = aws_key_pair.primary-key.key_name
  associate_public_ip_address = false
  subnet_id                   = aws_subnet.primary-subnet-01.id
  vpc_security_group_ids      = [aws_security_group.primary-db-tier.id]
  user_data                   = file(var.primary-db.user_data_path)
  tags = merge(
    var.udc_default_tags,
    {
      Name = join("-", ["Udacity m4 - db-instance", count.index + 1, "a"])
      Tier = "DB"
    }
  )
  root_block_device {
    volume_type = var.primary-db.storage-type
    volume_size = var.primary-db.storage-size
  }

}


