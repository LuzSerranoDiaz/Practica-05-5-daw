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