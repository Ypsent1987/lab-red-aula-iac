# Expone el identificador de la instancia para permitir
# su verificacion posterior desde Terraform o AWS CLI.

output "instance_id" {
  description = "Identificador de la instancia EC2 del portal."
  value       = aws_instance.web.id
}

# Expone la direccion IPv4 publica asignada a la instancia.
# Esta direccion permitira comprobar el portal mediante HTTP.

output "public_ip" {
  description = "Direccion IPv4 publica de la instancia EC2."
  value       = aws_instance.web.public_ip
}

# Expone el nombre DNS publico entregado por AWS.

output "public_dns" {
  description = "Nombre DNS publico de la instancia EC2."
  value       = aws_instance.web.public_dns
}