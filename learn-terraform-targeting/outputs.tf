output "bucket_name" {
  description = "Randomly generated bucket name."
  value       = aws_s3_bucket.bucket.bucket
}

output "bucket_arn" {
  description = "ARN of bucket"
  value       = aws_s3_bucket.bucket.arn
}

output "bucket_object_contents" {
  description = "Bucket object contents"
  value = aws_s3_object.objects.*.content
}