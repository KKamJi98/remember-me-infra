output "group_name" {
  value = aws_iam_group.example.name
}

output "user_names" {
  value = [for user in aws_iam_user.example : user.name]
}

output "passwords" {
  value = { for user, profile in aws_iam_user_login_profile.example : user => profile.encrypted_password }
}

output "formatted_decrypted_passwords" {
  value = local.formatted_decrypted_passwords
}
