variable "aws_region" {
  description = "Region AWS utilizada por el laboratorio."
  type        = string
  default     = "us-east-1"
}

# Valores del caso demostrativo del laboratorio.
# Se mantienen fuera del modulo para demostrar reutilizacion
# y evitar acoplar la arquitectura a un escenario especifico.

variable "name_prefix" {
  description = "Prefijo utilizado para identificar los recursos del laboratorio."
  type        = string
  default     = "lab-red-aula"
}

variable "vpc_cidr" {
  description = "Bloque CIDR de la VPC utilizado en el caso demostrativo."
  type        = string
  default     = "10.20.0.0/16"
}

variable "public_subnet_cidr" {
  description = "Bloque CIDR de la subred publica del caso demostrativo."
  type        = string
  default     = "10.20.10.0/24"
}

# Tipo de instancia utilizado por el servidor web
# del caso demostrativo del laboratorio.

variable "instance_type" {
  description = "Tipo de instancia EC2 utilizado por el laboratorio."
  type        = string
  default     = "t3.micro"
}