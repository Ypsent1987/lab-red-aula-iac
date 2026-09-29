# Identificador de la instancia EC2 creada por el laboratorio.

output "instance_id" {
  description = "Identificador de la instancia EC2 del portal."
  value       = module.compute.instance_id
}

# Direccion IPv4 publica asignada a la instancia.

output "public_ip" {
  description = "Direccion IPv4 publica utilizada para acceder al portal."
  value       = module.compute.public_ip
}

# Nombre DNS publico entregado por AWS.

output "public_dns" {
  description = "Nombre DNS publico de la instancia EC2."
  value       = module.compute.public_dns
}

# URL HTTP directa del portal desplegado.

output "portal_url" {
  description = "URL HTTP del portal desplegado por Terraform."
  value       = "http://${module.compute.public_ip}"
}