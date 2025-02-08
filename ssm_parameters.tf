locals {
  host_list_ssm_name = "/${local.name_prefix}/host_list"
  site_name_ssm_name = "/${local.name_prefix}/site_name"
}

resource "aws_ssm_parameter" "host_list" {
  name  = local.host_list_ssm_name
  type  = "String"
  value = join(",", aws_instance.main.*.private_dns)
}

resource "aws_ssm_parameter" "site_name" {
  name  = local.site_name_ssm_name
  type  = "String"
  value = "${local.name_prefix}-taco-wagon"
}

data "aws_iam_policy_document" "ssm_access" {
  statement {
    effect = "Allow"
    actions = [
      "ssm:GetParameter"
    ]
    resources = [
      aws_ssm_parameter.host_list.arn,
      aws_ssm_parameter.site_name.arn
    ]
  }
}
