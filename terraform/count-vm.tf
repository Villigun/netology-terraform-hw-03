resource "yandex_compute_instance" "web" {
  count = 2
  name            = "web-${count.index + 1}"

  zone            = var.vm-web_resources["web"].zone
  platform_id     = var.vm-web_resources["web"].platform_id
  resources {
    cores         = var.vm-web_resources["web"].cores
    memory        = var.vm-web_resources["web"].memory
    core_fraction = var.vm-web_resources["web"].core_fraction
  }

  boot_disk {
    initialize_params {
      size        = var.vm-web_resources["web"].hdd_size
      type        = var.vm-web_resources["web"].hdd_type
      image_id    = var.vm-web_resources["web"].image_id 
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

  # Выставляем зависимость от main и replica
  depends_on = [
    yandex_compute_instance.backend_vm["main"],
    yandex_compute_instance.backend_vm["replica"]
  ]  
}
