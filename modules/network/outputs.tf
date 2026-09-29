# Expone el identificador de la VPC para que otros módulos
# puedan relacionar sus recursos con esta red.

output "vpc_id" {
  description = "Identificador de la VPC creada por el modulo de red."
  value       = aws_vpc.this.id
}

# Expone la subred publica donde posteriormente se desplegara
# la instancia utilizada por el portal del laboratorio.

output "public_subnet_id" {
  description = "Identificador de la subred publica."
  value       = aws_subnet.public.id
}

# Expone el grupo de seguridad destinado al servidor web.
# El modulo de computo podra asociarlo a la instancia EC2.

output "web_security_group_id" {
  description = "Identificador del grupo de seguridad del portal web."
  value       = aws_security_group.web.id
}