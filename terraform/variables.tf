variable "aws_region" {
  description = "Home region for the lab. Stay in one region."
  type        = string
  default     = "us-east-1"
}

variable "name" {
  description = "Name prefix for lab resources."
  type        = string
  default     = "cloudsec-lab"
}

variable "container_port" {
  type    = number
  default = 8080
}

variable "desired_count" {
  description = "Fargate tasks. Default 0 so first apply doesn't fail before the image is in ECR. Set to 1 after docker push."
  type        = number
  default     = 0
}

variable "allowed_cidr" {
  description = "Who can hit the task on container_port. Tighten to home IP/32 when you can."
  type        = string
  default     = "0.0.0.0/0"
}

variable "image_tag" {
  type    = string
  default = "latest"
}

variable "github_org" {
  description = "GitHub org/user that owns the public lab repo."
  type        = string
  default     = "glorified-g"
}

variable "github_repo" {
  description = "Repo allowed to assume the OIDC deploy role (main branch only)."
  type        = string
  default     = "cloudsec-lab"
}

variable "github_owner_id" {
  description = "GitHub numeric user/org id (appears in the OIDC sub claim)."
  type        = string
  default     = "91491924"
}

variable "github_repo_id" {
  description = "GitHub numeric repo id (appears in the OIDC sub claim)."
  type        = string
  default     = "1337902461"
}

variable "tags" {
  type = map(string)
  default = {
    Environment  = "Lab"
    Owner        = "Ken"
    AutoShutdown = "true"
    Project      = "cloudsec-lab"
    ManagedBy    = "terraform"
  }
}
