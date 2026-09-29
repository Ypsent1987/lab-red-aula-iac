#!/bin/bash

# Detiene el script si ocurre un error durante la configuracion.
set -e

# Instala el servidor web Apache disponible en Amazon Linux 2023.
dnf install -y httpd

# Crea una pagina sencilla para verificar que la instancia
# fue configurada automaticamente mediante user_data.

cat > /var/www/html/index.html <<'EOF'
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Laboratorio IaC</title>
</head>
<body>
    <h1>Portal desplegado con Terraform</h1>
    <p>Infraestructura creada mediante Infrastructure as Code.</p>
    <p>Servidor web configurado automaticamente con EC2 User Data.</p>
</body>
</html>
EOF

# Habilita Apache para que inicie automaticamente
# y arranca el servicio inmediatamente.

systemctl enable httpd
systemctl start httpd