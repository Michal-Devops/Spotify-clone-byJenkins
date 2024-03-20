resource "aws_instance" "jenkins_server" {
  ami           = "ami-080e1f13689e07408 (64-bit (x86)" 
  instance_type = "t2.large"
  key_name      = aws_key_pair.jenkins.key_name
  security_groups = [aws_security_group.jenkins_sg.name]

  tags = {
    Name = "Jenkins Server"
  }
}

resource "aws_instance" "monitoring_instance" {
  ami           = "ami-080e1f13689e07408 (64-bit (x86)" 
  instance_type = "t2.medium"
  key_name      = aws_key_pair.monitoring.key_name
  security_groups = [aws_security_group.monitoring_sg.name]

  tags = {
    Name = "Monitoring Instance"
  }
}
