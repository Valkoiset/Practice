resource "google_compute_instance" "default" {
  count = "${length(var.name_count)}"
  name = "list-${count.index+1}"
  machine_type = var.environment == "production" ? var.machine_type : var.machine_type_dev
  zone = "europe-west1-b"

  boot_disk {
    initialize_params {
      # image = "ubuntu-os-cloud/ubuntu-1604-lts" # this image was in course example and didn't work
      image = var.image # this one found on github forum and worked
    }
  }

  network_interface {
    network = "default"
  }

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }

  # depends_on is a good tool to control the order of exexcution (creation of instances in this case)
  # since default instance is dependent on the second one, terraform will built second instance in a first order
  # and then built default one afterwards even though default is written first in the code
  # depends_on = [google_compute_instance.second]
}

# # ------------------------------------------------
# resource "google_compute_instance" "second" {
#   count = "1"
#   name = "second-${count.index+1}"
#   machine_type = var.machine_type["dev"]
#   zone = "europe-west1-b"

#   boot_disk {
#     initialize_params {
#       # image = "ubuntu-os-cloud/ubuntu-1604-lts" # this image was in course example and didn't work
#       image = var.image # this one found on github forum and worked
#     }
#   }

#   network_interface {
#     network = "default"
#   }

#   service_account {
#     scopes = ["userinfo-email", "compute-ro", "storage-ro"]
#   }
# }

output "machine_type" { value = "${google_compute_instance.default.*.machine_type}" }
output "name" { value = "${google_compute_instance.default.*.name}" }
output "zone" { value = "${google_compute_instance.default.*.zone}" }

output "instance_id" { value = "${join(",", google_compute_instance.default.*.id)}" }
