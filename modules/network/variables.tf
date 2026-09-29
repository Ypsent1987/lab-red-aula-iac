variable "name_prefix" {
  description = "Prefijo utilizado para nombrar los recursos de red."
  type        = string
}

variable "vpc_cidr" {
  description = "Bloque CIDR asignado a la VPC."
  type        = string
}

variable "public_subnet_cidr" {
  description = "Bloque CIDR asignado a la subred publica."
  type        = string
}