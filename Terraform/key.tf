resource "tls_private_key" "jenkins_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "jenkins" {
  key_name   = "spotify-rsa"
  public_key = tls_private_key.jenkins_key.public_key_openssh
}

resource "tls_private_key" "monitoring_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "monitoring" {
  key_name   = "monitoring-rsa"
  public_key = tls_private_key.monitoring_key.public_key_openssh
}
