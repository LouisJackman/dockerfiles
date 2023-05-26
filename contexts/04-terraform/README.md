# terraform

Run Terraform from within the container, optionally providing
`AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` environment variables to avoid
needing to specify them per `terraform apply` against AWS resources.

This container is kept minimal to reduce the potential risk of doing so. As
such, it doesn't have any fancy Terraform development tools. For an environment
that has such capabilities, see `terraform-dev` which should _not_ have actual
`apply`s performed within.

