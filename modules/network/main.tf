# Crea la red virtual que contendrá los recursos del laboratorio.
# El bloque CIDR se recibe como variable para mantener el módulo reutilizable.

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.name_prefix}-vpc"
  }
}

# Crea una subred pública dentro de la VPC.
# La referencia aws_vpc.this.id establece la dependencia con la VPC
# sin utilizar identificadores escritos manualmente.

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.name_prefix}-public-subnet"
  }
}

# Conecta la VPC con Internet.
# Por sí solo el Internet Gateway no entrega conectividad completa:
# posteriormente se requiere una ruta que lo utilice.

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.name_prefix}-igw"
  }
}

# Define el enrutamiento de la red pública.
# La ruta 0.0.0.0/0 envía el tráfico destinado a Internet
# hacia el Internet Gateway asociado a la VPC.

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "${var.name_prefix}-public-rt"
  }
}

# Asocia la subred publica con la tabla de rutas definida anteriormente.
# Sin esta asociacion, la subred no utilizaria esta ruta hacia Internet.

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}


# Define el grupo de seguridad utilizado por el servidor web.
# El grupo pertenece a la VPC del laboratorio.

resource "aws_security_group" "web" {
  name_prefix = "${var.name_prefix}-web-"
  description = "Control de trafico para el portal web del laboratorio."
  vpc_id      = aws_vpc.this.id

  tags = {
    Name = "${var.name_prefix}-web-sg"
  }
}

# Permite solicitudes HTTP hacia el portal desde Internet.
# En este laboratorio no se habilita acceso SSH de entrada.

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.web.id

  description = "Permite HTTP hacia el portal web."
  ip_protocol = "tcp"
  from_port   = 80
  to_port     = 80
  cidr_ipv4   = "0.0.0.0/0"
}

# Permite que la instancia asociada inicie conexiones hacia el exterior.

resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.web.id

  ip_protocol = "-1"
  cidr_ipv4   = "0.0.0.0/0"
}