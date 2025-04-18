output "bucket_name" {
    description = "S3 Bucket"
    value = aws_s3_bucket.example.bucket
}