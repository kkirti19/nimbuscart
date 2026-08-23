terraform {
  backend "s3" {
    bucket         = "nimbuscart-tf-state-261414899502"
    key            = "nimbuscart/terraform.tfstate"
    region         = "ap-southeast-2"
    dynamodb_table = "nimbuscart-tf-lock"
    encrypt        = true
  }
}

