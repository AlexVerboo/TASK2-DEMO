terraform {
  backend "gcs" {
    bucket  = "bucketalexdemo"
    prefix  = "terraform/task2"
  }
}