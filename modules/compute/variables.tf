# Prefijo utilizado para identificar los recursos de computo.

variable "name_prefix" {
  description = "Prefijo utilizado para nombrar los recursos de computo."
  type        = string
}

# Subred donde se desplegara la instancia.
# Este valor sera entregado por el modulo de red.

variable "subnet_id" {
  description = "Identificador de la subred donde se desplegara la instancia EC2."
  type        = string
}

# Grupo de seguridad que controlara el trafico de la instancia.
# Este valor tambien sera entregado por el modulo de red.

variable "security_group_id" {
  description = "Identificador del grupo de seguridad asociado a la instancia."
  type        = string
}

# Tipo de instancia utilizado por el laboratorio.

variable "instance_type" {
  description = "Tipo de instancia EC2 utilizado por el laboratorio."
  type        = string
}

# Contenido del script de inicializacion que ejecutara la instancia
# durante su primer arranque.

variable "user_data" {
  description = "Script de inicializacion entregado a la instancia EC2."
  type        = string
}