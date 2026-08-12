output "state_bucket_name" {
  description = "Name of the S3 bucket for Terraform state"
  value       = aws_s3_bucket.state.id
}

output "state_bucket_arn" {
  description = "ARN of the S3 bucket for Terraform state"
  value       = aws_s3_bucket.state.arn
}

output "state_logs_bucket_name" {
  description = "Name of the S3 bucket for Terraform state logs"
  value       = aws_s3_bucket.state_logs.id
}

output "state_logs_bucket_arn" {
  description = "ARN of the S3 bucket for Terraform state logs"
  value       = aws_s3_bucket.state_logs.arn
}