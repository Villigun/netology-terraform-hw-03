output "vms_public_ips" {
  description = "Внешние IP всех ВМок"
  value = merge(
    { for name, vm in yandex_compute_instance.backend_vm : name => vm.network_interface[0].nat_ip_address },
    { for i, vm in yandex_compute_instance.web           : vm.name => vm.network_interface[0].nat_ip_address },
    { "storage" = yandex_compute_instance.storage.network_interface[0].nat_ip_address}
  )
}

output "ansible_inventory" {
  description = "Вывод имени, IP-адреса и FQDN всех ВМок"
  value       = local.inventory_content
  sensitive   = false
}

