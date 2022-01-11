resource "aws_s3_bucket" "nlppipeline" {
  bucket = "pipeline-${local.full_name}"
  acl = "private"
  force_destroy = true # Would not normally put Force Destroy Var, but for sake clean destroy for this demo

  versioning {
    enabled = true
  }

}