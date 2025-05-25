data "aws_cloudfront_origin_request_policy" "all" {
  name = "Managed-AllViewer"
}

data "aws_cloudfront_origin_request_policy" "all_no_host" {
  name = "Managed-AllViewerExceptHostHeader"
}
