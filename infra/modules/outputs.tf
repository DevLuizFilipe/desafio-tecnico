output "lb_dns_name" {
  description = "Public LB address to connect too"
  value       = aws_lb.main.dns_name
}