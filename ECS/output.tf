#------------------------------------------------------------------------------
# ECS CLUSTER
#------------------------------------------------------------------------------
output "ecs_cluster_name" {
  description = "The name of the cluster"
  value       = aws_ecs_cluster.cluster.name
}

output "ecs_cluster_id" {
  description = "The Amazon ID that identifies the cluster"
  value       = aws_ecs_cluster.cluster.id
}

output "ecs_cluster_arn" {
  description = "The Amazon Resource Name (ARN) that identifies the cluster"
  value       = aws_ecs_cluster.cluster.arn
}
