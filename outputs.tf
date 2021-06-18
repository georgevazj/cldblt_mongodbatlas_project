output "project_id" {
  value = mongodbatlas_project.project.id
}

output "project_name" {
  value = mongodbatlas_project.project.name
}

output "user_id" {
  value = mongodbatlas_database_user.dbUser.id
}

output "user_name" {
  value = mongodbatlas_database_user.dbUser.username
}