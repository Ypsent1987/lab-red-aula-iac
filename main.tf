# Instancia el modulo de red utilizando los valores
# definidos por el caso demostrativo del laboratorio.

module "network" {
  source = "./modules/network"

  name_prefix       = var.name_prefix
  vpc_cidr          = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
}