resource "yandex_compute_disk" "onegb_disk" {
  count = 3
  name        = "onegb_disk-${count.index + 1}"
  size        = 1 #Gb
  type        = "network-hdd"
  description = "onegb_disk ${count.index + 1}"
}

resource "yandex_compute_instance" "storage" {
  name        = "storage"
  platform_id = var.global_platform_id
  zone        = var.global_zone

  resources {
    cores  = 2
    memory = 2
    core_fraction = 5
  }

  boot_disk {
    initialize_params {
      image_id = var.global_image_id
      size     = 10
      type     = "network-hdd"
    }
  }

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id  # существующая подсеть
    nat                = true
    security_group_ids = [yandex_vpc_security_group.example.id] # привязываем группу безопасности
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.ssh-key_path)}"
  }

  # Подключаем диски
  dynamic "secondary_disk" {
    for_each = { for d in yandex_compute_disk.onegb_disk : d.id => d }
    content {
      disk_id = secondary_disk.value.id
    }
  }
}