terraform {
  backend "gcs" {
    bucket = "adrian-cdw-test--tfbucket-001"
    prefix = "terraform/state"
  }
}