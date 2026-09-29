# Instancia el modulo de red utilizando los valores
# definidos por el caso demostrativo del laboratorio.

module "network" {
  source = "./modules/network"

  name_prefix        = var.name_prefix
  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
}

# Despliega el servidor web utilizando la infraestructura
# entregada por el modulo de red.

module "compute" {
  source = "./modules/compute"

  name_prefix       = var.name_prefix
  subnet_id         = module.network.public_subnet_id
  security_group_id = module.network.web_security_group_id
  instance_type     = var.instance_type

  # Lee el script que configurara automaticamente
  # el servidor durante su primer arranque.

  user_data = file("${path.module}/user_data/web.sh")
}