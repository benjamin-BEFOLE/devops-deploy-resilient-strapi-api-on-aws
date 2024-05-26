resource "aws_iam_instance_profile" "profile" {
  name = "strapi_profile"
  role = aws_iam_role.role.name
}

resource "aws_iam_role" "role" {
  name                = "strapi_role"
  assume_role_policy  = data.aws_iam_policy_document.assume_role.json
  managed_policy_arns = [aws_iam_policy.read_s3.arn, "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "read_s3" {
  name = "policy-read-s3"

  policy = data.aws_iam_policy_document.read_s3_policy.json
}

data "aws_iam_policy_document" "read_s3_policy" {
  statement {
    effect    = "Allow"
    actions   = ["s3:ListBucket"]
    resources = ["${data.aws_s3_bucket.strapi_bucket_backend.arn}"]
    condition {
      test     = "StringLike"
      variable = "s3:prefix"
      values   = ["artefacts/strapi/*"]
    }
  }

  statement {
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["${data.aws_s3_bucket.strapi_bucket_backend.arn}/artefacts/strapi/*"]
  }

  statement {
    effect    = "Allow"
    actions   = ["secretsmanager:GetSecretValue"]
    resources = [data.aws_secretsmanager_secret.api_secrets.arn, data.aws_secretsmanager_secret.database_password.arn]
  }
}
