variable "image" { default = "debian-cloud/debian-9" }
variable "path" { default = "/Users/valkoiset/Desktop/courses/Udemy/terraform/credentials" }
variable "environment" { default = "dev" }
variable "zone" { default = "europe-west1-b" }
variable "machine_type" { default = "n1-standard-1" }
variable "machine_type_dev" { default = "n1-standard-4" }
variable "machine_count" { default = "1"}
variable "name1" { default = "name1"}
variable "name2" { default = "name2"}
variable "name3" { default = "name3"}

# variable "machine_type" { 
#   type = map
#   default = {
#     "dev" = "n1-standard-1"
#     "prod" = "production-box-wont-work"
#   }
# }

variable "name_count" {default = ["server1", "server2", "server3"]}
