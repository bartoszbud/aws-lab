resource "aws_iam_group" "groups" {
  name = var.group_name
}

resource "aws_iam_group_policy_attachment" "group_policy_attachement" {
  for_each   = var.policy_arns
  group      = aws_iam_group.groups.name
  policy_arn = each.value

  depends_on = [aws_iam_group.groups]
}