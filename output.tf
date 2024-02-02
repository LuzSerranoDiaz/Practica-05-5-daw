# Mostramos la IP pública de la instancia
output "elastic_ip_backend" {
  value = aws_eip.ip_elastica_backend.public_ip
}
output "elastic_ip_frontend" {
  value = aws_eip.ip_elastica_frontend.public_ip
}