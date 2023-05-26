# terraform-dev

Develop Terraform configurations. Do not run actual Terraform applications
inside, as it'll require exposing your cloud provider keys to an environment
with a lot of third party packages present; for that, use the `terraform` image
instead.

