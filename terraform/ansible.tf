locals {
  web_hosts = [
    for vm in yandex_compute_instance.web :
    {
      name    = vm.name
      address = vm.network_interface[0].nat_ip_address
      fqdn    = vm.fqdn
    }
  ]

  main_hosts = [
    for vm in yandex_compute_instance.backend_vm :
    {
      name    = vm.name
      address = vm.network_interface[0].nat_ip_address
      fqdn    = vm.fqdn
    } if vm.name == "main"
  ]

  replica_hosts = [
    for vm in yandex_compute_instance.backend_vm :
    {
      name    = vm.name
      address = vm.network_interface[0].nat_ip_address
      fqdn    = vm.fqdn
    } if vm.name == "replica"
  ]

  storage_hosts = [
    {
      name    = yandex_compute_instance.storage.name
      address = yandex_compute_instance.storage.network_interface[0].nat_ip_address
      fqdn    = yandex_compute_instance.storage.fqdn
    }
  ]

  inventory_content = templatefile("${path.module}/ansible.tftpl", {
    web_hosts     = local.web_hosts
    main_hosts    = local.main_hosts
    replica_hosts = local.replica_hosts
    storage_hosts = local.storage_hosts
  })
}

resource "local_file" "ansible_inventory" {
  filename = "${path.module}/inventory.ini"
  content  = local.inventory_content
}