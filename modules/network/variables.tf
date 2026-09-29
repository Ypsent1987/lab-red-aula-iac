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

# Zona de disponibilidad donde se desplegara la subred publica.
# Se recibe desde el modulo raiz para evitar una seleccion implicita de AWS.

variable "availability_zone" {
  description = "Zona de disponibilidad utilizada por la subred publica."
  type        = string
}