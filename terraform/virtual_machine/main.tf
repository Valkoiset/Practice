locals {
   name = "list-${var.name1}-${var.name2}-${var.name3}"
}

resource "google_compute_instance" "default" {
  count = "${var.machine_count}"
  name = "${local.name}"
  machine_type = var.environment == "production" ? var.machine_type : var.machine_type_dev
  zone = var.zone
  can_ip_forward = false
  description = "This is our Virtual Machine"

  tags = ["allow-http", "allow-https"] # Firewall

  boot_disk {
    initialize_params {
      # image = "ubuntu-os-cloud/ubuntu-1604-lts" # this image was in course example and didn't work
      image = var.image # this one found on github forum and worked
      size = "20" # 20 Gb disk size
    }
  }

  labels = {
    name = "list-${count.index+1}"
    machine_type = var.environment == "production" ? var.machine_type : var.machine_type_dev
  }

  network_interface {
    network = "default"
  }

  metadata = {
    size = "20"
    foo = "bar"
  }

  metadata_startup_script = "echo hi > /test.txt"

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

resource "google_compute_disk" "default" {
  name = "test-desk"
  type = "pd-ssd"
  zone = "europe-west1-b"
  size = "10"
}

resource "google_compute_attached_disk" "default" {
  disk = "${google_compute_disk.default.self_link}"
  instance = "${google_compute_instance.default[0].self_link}"
}

output "machine_type" { value = "${google_compute_instance.default.*.machine_type}" }
output "name" { value = "${google_compute_instance.default.*.name}" }
output "zone" { value = "${google_compute_instance.default.*.zone}" }

output "instance_id" { value = "${join(",", google_compute_instance.default.*.id)}" }
