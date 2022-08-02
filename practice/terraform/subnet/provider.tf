variable "path" { default = "/Users/valkoiset/Desktop/courses/Udemy/terraform/credentials" }

provider "google" {
  project = "valkoiset"
  region = "europe-west1-b"
  credentials = "${file("${var.path}/secrets.json")}"
  # version = "2.6"
  # required_providers {
  #   version = "2.6"
  # }
  # features = {}
}
