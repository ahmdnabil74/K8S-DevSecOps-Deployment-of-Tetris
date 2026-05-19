resource "aws_iam_role_policy_attachment" "iam-policy" {
  role = aws_iam_role.iam-role.name #name of cule that created in previous code
  # Just for testing purpose, don't try to give administrator access
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

#connect iam role with policy 
