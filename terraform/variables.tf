variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-1" # 東京リージョンなど適宜変更
}

variable "environment" {
  description = "Environment tag (e.g., dev, prod)"
  type        = string
  default     = "dev"
}
