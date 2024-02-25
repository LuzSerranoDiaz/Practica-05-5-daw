# Practica-05-5-daw

## variables
```tf
variable "region" {
  description = "Región de AWS donde se creará la instancia"
  type        = string
  default     = "us-east-1"
}

variable "allowed_ingress_ports_frontend" {
  description = "Puertos de entrada del grupo de seguridad"
  type        = list(number)
  default     = [22, 80, 443]
}

variable "allowed_ingress_ports_backend" {
  description = "Puertos de entrada del grupo de seguridad"
  type        = list(number)
  default     = [22, 3306]
}

variable "sg_name_f" {
  description = "Nombre del grupo de seguridad"
  type        = string
  default     = "sg_frontend_terraform"
}

variable "sg_name_b" {
  description = "Nombre del grupo de seguridad"
  type        = string
  default     = "sg_backend_terraform"
}

variable "sg_description_f" {
  description = "Descripción del grupo de seguridad"
  type        = string
  default     = "Grupo de seguridad frontend"
}
variable "sg_description_b" {
  description = "Descripción del grupo de seguridad"
  type        = string
  default     = "Grupo de seguridad backend"
}

variable "ami_id" {
  description = "Identificador de la AMI"
  type        = string
  default     = "ami-00874d747dde814fa"
}

variable "instance_type" {
  description = "Tipo de instancia"
  type        = string
  default     = "t2.small"
}

variable "key_name" {
  description = "Nombre de la clave pública"
  type        = string
  default     = "vockey"
}

variable "instance_name_frontend" {
  description = "Nombre de la instancia"
  type        = string
  default     = "instancia_terraform_frontend"
}

variable "instance_name_backend" {
  description = "Nombre de la instancia"
  type        = string
  default     = "instancia_terraform_backend"
}
```
## main
```tf
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
```
Se crea los grupos de seguridad sg_frontend_terraform y sg_backend_terraform.
```tf

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
```
Se le añaden las reglas de entrada y salida a sg_frontend_terraform.
```tf
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
```
Se le añaden las reglas de entrada y salida a sg_backend_terraform.
```tf
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
```
Se crea la instancia instancia_terraform_frontend, de tipo t2.small, clave vockey, grupo de seguridad sg_frontend_terraform y la imagen ami-00874d747dde814fa.
```tf
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
```
Se crea la instancia instancia_terraform_backend, de tipo t2.small, clave vockey, grupo de seguridad sg_backend_terraform y la imagen ami-00874d747dde814fa.
```tf
# Creamos una IP elástica y la asociamos a la instancia
resource "aws_eip" "ip_elastica_backend" {
  instance = aws_instance.instancia_terraform_backend.id
}

resource "aws_eip" "ip_elastica_frontend" {
  instance = aws_instance.instancia_terraform_frontend.id
}
```
Se crea y añade una ip elastica a la instancia instancia_terraform_frontend.

## Output

```
# Mostramos la IP pública de la instancia
output "elastic_ip_backend" {
  value = aws_eip.ip_elastica_backend.public_ip
}
output "elastic_ip_frontend" {
  value = aws_eip.ip_elastica_frontend.public_ip
}
```
Muestra la ip publica de la instancia frontend.
