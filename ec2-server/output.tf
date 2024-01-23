output "instance-dns" {
  value = aws_instance.main.public_dns
}

output "eip-public-ip" {
  value = aws_eip.bar.public_ip
}
