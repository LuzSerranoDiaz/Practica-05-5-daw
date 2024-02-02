# Configuramos el proveedor de AWS
provider "aws" {
  region = var.region
}

# Creamos el grupo de seguridad
resource "aws_security_group" "sg_backend_terraform" {
  name        = var.sg_name_b
  description = var.sg_description_b
}

resource "aws_security_group" "sg_frontend_terraform" {
  name        = var.sg_name_f
  description = var.sg_description_f
}

# Creamos las reglas de entrada del grupo de seguridad. 
# Utilizamos un bucle para recorrer la lista de puertos definida como variable
resource "aws_security_group_rule" "ingress1" {
  security_group_id = aws_security_group.sg_frontend_terraform.id
  type              = "ingress"

  count       = length(var.allowed_ingress_ports_frontend)
  from_port   = var.allowed_ingress_ports_frontend[count.index]
  to_port     = var.allowed_ingress_ports_frontend[count.index]
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "ingress2" {
  security_group_id = aws_security_group.sg_frontend_terraform.id
  type        = "ingress"
  from_port   = 0
  to_port     = 0
  protocol    = "ICMP"
  cidr_blocks = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "egress1" {
  security_group_id = aws_security_group.sg_frontend_terraform.id
  type              = "egress"

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

#Backend
resource "aws_security_group_rule" "ingress3" {
  security_group_id = aws_security_group.sg_backend_terraform.id
  type              = "ingress"

  count       = length(var.allowed_ingress_ports_backend)
  from_port   = var.allowed_ingress_ports_backend[count.index]
  to_port     = var.allowed_ingress_ports_backend[count.index]
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "ingress4" {
  security_group_id = aws_security_group.sg_backend_terraform.id
  type              = "ingress"

  from_port   = 0
  to_port     = 65535
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "ingress5" {
  security_group_id = aws_security_group.sg_backend_terraform.id
  type              = "ingress"

  from_port   = 0
  to_port     = 0
  protocol    = "ICMP"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "egress2" {
  security_group_id = aws_security_group.sg_backend_terraform.id
  type              = "egress"

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

# Creamos una instancia EC2
resource "aws_instance" "instancia_terraform_frontend" {
  ami             = var.ami_id
  instance_type   = var.instance_type
  key_name        = var.key_name
  security_groups = [aws_security_group.sg_frontend_terraform.name]

  tags = {
    Name = var.instance_name_frontend
  }
}

# Creamos una instancia EC2
resource "aws_instance" "instancia_terraform_backend" {
  ami             = var.ami_id
  instance_type   = var.instance_type
  key_name        = var.key_name
  security_groups = [aws_security_group.sg_backend_terraform.name]

  tags = {
    Name = var.instance_name_backend
  }
}

# Creamos una IP elástica y la asociamos a la instancia
resource "aws_eip" "ip_elastica_backend" {
  instance = aws_instance.instancia_terraform_backend.id
}

resource "aws_eip" "ip_elastica_frontend" {
  instance = aws_instance.instancia_terraform_frontend.id
}