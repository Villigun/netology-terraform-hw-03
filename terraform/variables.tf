###cloud vars
variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network&subnet name"
}

variable "ssh-key_path" {
  type    = string
  description = "Путь к ssh-key. Описан в personal.auto.tfvars"
  sensitive   = true # Отключаем вывод значения переменной в plan и apply
}

variable "vm-web_resources" {
  type = map(any)
}

variable "vm-backend_resources" {
  description = "Параметры ВМ для for each"
  type = list(object({
    zone          = string
    platform_id   = string
    vm_name       = string
    cores         = number
    memory        = number
    core_fraction = number
    hdd_size      = number
    hdd_type      = string
    image_id      = string
  }))
}

locals {
  vm_map = { for vm in var.vm-backend_resources : vm.vm_name => vm }
}

# === Описание глобальных переменных === #

variable "global_image_id" {
  description = "Image ID для создания ВМок"
  type = string
}

variable "global_platform_id" {
  description = "Image ID для создания ВМок"
  type = string
}

variable "global_zone" {
  description = "Image ID для создания ВМок"
  type = string
}