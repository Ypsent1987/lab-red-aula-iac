# Crea la instancia que alojara el portal web del laboratorio.
# La AMI se obtiene dinamicamente mediante data.aws_ami.amazon_linux.

resource "aws_instance" "web" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type

  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]

  # El contenido se recibe desde fuera del modulo para separar
  # la infraestructura del proceso de configuracion del servidor.

  user_data                   = var.user_data
  user_data_replace_on_change = true

  # Exige IMDSv2 para el acceso al servicio de metadatos.

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tags = {
    Name = "${var.name_prefix}-web"
  }
}