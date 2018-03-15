# The elastic beanstalk application
resource "aws_elastic_beanstalk_application" "live-applications" {
  name        = "Live-Applications"
  description = "Production-Applications"
}
