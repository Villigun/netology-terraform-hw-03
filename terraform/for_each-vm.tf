resource "yandex_compute_instance" "backend_vm" {
  for_each = local.vm_map

  zone = each.value.zone
  name = each.value.vm_name
  platform_id = each.value.platform_id
  resources {
    cores  = each.value.cores
    memory = each.value.memory
    core_fraction = each.value.core_fraction
  }

  boot_disk {
    initialize_params {
      size        = each.value.hdd_size
      type        = each.value.hdd_type
      image_id    = each.value.image_id 
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
}
