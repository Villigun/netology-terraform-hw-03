# Yandex Cloud

# === Описание глобальных переменных === #
global_image_id    = "fd8nvsua0sq94uqoep04" # Ubuntu 20.04 LTS
global_platform_id = "standard-v1"
global_zone        = "ru-central1-a"

# === Описание переменных для web инстансов === #
vm-web_resources = {
  web={
    zone          = "ru-central1-a"
    platform_id   = "standard-v1"
    cores         = 2
    memory        = 2
    core_fraction = 5
    hdd_size      = 10
    hdd_type      = "network-hdd"
    image_id      = "fd8nvsua0sq94uqoep04" # Ubuntu 20.04 LTS
   } 
}

# === Описание переменных для backend инстансов === #
vm-backend_resources = [
  {
    vm_name       = "main"
    zone          = "ru-central1-a"
    platform_id   = "standard-v1"
    cores         = 2
    memory        = 2
    core_fraction = 20
    hdd_size      = 20
    hdd_type      = "network-hdd"
    image_id      = "fd8nvsua0sq94uqoep04" # Ubuntu 20.04 LTS
  },
  {
    vm_name       = "replica"
    zone          = "ru-central1-a"
    platform_id   = "standard-v1"    
    cores         = 2
    memory        = 2
    core_fraction = 5
    hdd_size      = 10
    hdd_type      = "network-hdd"
    image_id      = "fd8nvsua0sq94uqoep04" # Ubuntu 20.04 LTS
  }
]
