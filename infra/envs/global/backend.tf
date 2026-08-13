terraform {
  backend "s3" {
    bucket       = "global-iam-state-20260811212004932700000002"
    key          = "terraform.tfstate"
    region       = "eu-west-1"
    use_lockfile = true
  }
}