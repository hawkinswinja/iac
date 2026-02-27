output "vpc_id" {
  value = module.vpc.vpc_id
}

output "ecs_cluster_name" {
  value = module.ecs.cluster_name
}

output "web_service_name" {
  value = module.ecs.web_service_name
}

output "debug_service_name" {
  value = module.ecs.debug_service_name
}

output "web_ecr_repository_url" {
  value = module.ecr.web_repository_url
}

output "debug_ecr_repository_url" {
  value = module.ecr.debug_repository_url
}

output "service_discovery_namespace" {
  value = module.service_discovery.namespace_name
}
