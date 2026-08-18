output "ecr_repository_url" {
  value = aws_ecr_repository.app.repository_url
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.lab.name
}

output "ecs_service_name" {
  value = aws_ecs_service.app.name
}

output "push_commands" {
  value = <<-EOT
    aws ecr get-login-password --region ${var.aws_region} --profile ken-lab | docker login --username AWS --password-stdin ${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com
    docker tag cloudsec-lab:latest ${aws_ecr_repository.app.repository_url}:latest
    docker push ${aws_ecr_repository.app.repository_url}:latest
  EOT
}

output "task_ip_command" {
  value = <<-EOT
    aws ecs list-tasks --cluster ${aws_ecs_cluster.lab.name} --service-name ${aws_ecs_service.app.name} --desired-status RUNNING --profile ken-lab --query 'taskArns[0]' --output text
  EOT
}

output "stop_billing" {
  value = "cd terraform && terraform apply -auto-approve -var='desired_count=0'   # or terraform destroy"
}
