plugin "aws" {
  enabled = true
  version = "0.33.0"
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
}

# Turn on useful rules explicitly (optional; aws pack enables many by default)
rule "aws_instance_invalid_type" {
  enabled = true
}

# You can turn warnings into errors if you like:
# rule "aws_instance_invalid_ami" { enabled = true }
