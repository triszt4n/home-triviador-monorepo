locals {
  allowed_methods_types = {
    get_head     = ["GET", "HEAD"]
    get_head_opt = ["GET", "HEAD", "OPTIONS"]
    all          = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
  }
  cached_methods_types = {
    get_head     = ["GET", "HEAD"]
    get_head_opt = ["GET", "HEAD", "OPTIONS"]
  }
}
