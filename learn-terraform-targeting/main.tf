provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      hashicorp-learn = "resource-targeting"
    }
  }
}

resource "random_pet" "bucket_name" {
  length    = 5
  separator = "-"
  prefix    = "learning"
}

resource "aws_s3_bucket" "bucket" {
  bucket = random_pet.bucket_name.id

  
  tags = {
    Name = "my-bucket-${random_pet.bucket_name.id}"
  }
}

resource "random_pet" "object_names" {
  count = 4

  length    = 5
  separator = "_"
  prefix    = "learning"
}

resource "aws_s3_object" "objects" {
  count = 4

  key          = "${random_pet.object_names[count.index].id}.txt"
  bucket       = aws_s3_bucket.bucket.id
  content      = "Bucket object #${count.index}"
  content_type = "text/plain"
}