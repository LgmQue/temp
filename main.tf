terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.54"
    }
  }
  required_version = ">= 1.8.5"
}

# アクセスキーの設定
provider "aws" {
  region     = "ap-northeast-1"
  access_key = "XXX"
  secret_key = "XXX"
}

# パスワードポリシーの変更
resource "aws_iam_account_password_policy" "strict" {
  minimum_password_length        = 12
  require_uppercase_characters   = true
  require_lowercase_characters   = true
  require_numbers                = true
  require_symbols                = true
  allow_users_to_change_password = true
  password_reuse_prevention      = 3
}

# グループの作成
resource "aws_iam_group" "admin_group" {
  name = "admin_dojo"
}

# グループにポリシーをアタッチ
resource "aws_iam_group_policy_attachment" "admin_policy_attachment" {
  group      = aws_iam_group.admin_group.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# ユーザーの作成
resource "aws_iam_user" "admin_user" {
  name = "sample"
}

# ユーザーをグループに追加
resource "aws_iam_group_membership" "admin_group_membership" {
  name  = "admins-membership"
  group = aws_iam_group.admin_group.name
  users = [
    aws_iam_user.admin_user.name
  ]
}

# おまけ：エイリアスの設定
resource "aws_iam_account_alias" "alias" {
  account_alias = "terraform-dojo"
}
