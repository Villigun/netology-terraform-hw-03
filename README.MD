# Домашнее задание к занятию - «Управляющие конструкции в коде Terraform.

### Задание 1

В качестве ответа всегда полностью прикладывайте ваш terraform-код в git. Убедитесь что ваша версия Terraform ~>1.12.0

1.  Изучите проект.
2.  Инициализируйте проект, выполните код.

Приложите скриншот входящих правил «Группы безопасности» в ЛК Yandex Cloud .

#### Решение

```
yc vpc security-group list
+----------------------+---------------------------------+--------------------------------+----------------------+
|          ID          |              NAME               |          DESCRIPTION           |      NETWORK-ID      |
+----------------------+---------------------------------+--------------------------------+----------------------+
| enp9hk5moc07p9e8cje2 | default-sg-enpfc9a0a0sn86o7rmq4 | Default security group for     | enpfc9a0a0sn86o7rmq4 |
|                      |                                 | network                        |                      |
| enpd8kie13lm5pg15lj2 | default-sg-enp8fcbqldmp4dq97qt0 | Default security group for     | enp8fcbqldmp4dq97qt0 |
|                      |                                 | network                        |                      |
| enpdld4d79ncemuh0mgo | example_dynamic                 |                                | enpfc9a0a0sn86o7rmq4 |
+----------------------+---------------------------------+--------------------------------+----------------------+
```

### Задание 2

1.  Создайте файл count-vm.tf. Опишите в нём создание двух одинаковых ВМ web-1 и web-2 (не web-0 и web-1) с минимальными параметрами, используя мета-аргумент count loop. Назначьте ВМ созданную в первом задании группу безопасности.(как это сделать узнайте в документации провайдера yandex/compute_instance )
2.  Создайте файл for_each-vm.tf. Опишите в нём создание двух ВМ для баз данных с именами "main" и "replica" разных по cpu/ram/disk_volume , используя мета-аргумент for_each loop. Используйте для обеих ВМ одну общую переменную типа:  
```
variable "each_vm" {
  type = list(object({  vm_name=string, cpu=number, ram=number, disk_volume=number }))
}
```
3.  При желании внесите в переменную все возможные параметры. 
4.  ВМ из пункта 2.1 должны создаваться после создания ВМ из пункта 2.2.
5.  Используйте функцию file в local-переменной для считывания ключа ~/.ssh/id_rsa.pub и его последующего использования в блоке metadata, взятому из ДЗ 2. 
6.  Инициализируйте проект, выполните код.

#### Решение

1.  Создаем [count-vm.tf](!!!)  
2.  Создаем [for_each-vm.tf](!!!)  
В [variables.tf](!!!) добавляем переменные  

```
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
```

В [terraform.tfvars](!!!) также добавляем переменные  

```
vm-web_resources = {
  web={
    zone          = "ru-central1-a"
    platform_id   = "standard-v1"
    cores         = 2
    memory        = 2
    core_fraction = 5
    hdd_size      = 10
    hdd_type      = "network-hdd"
    image_id      = "fd88jdvngivc0n3vuoq7" # Ubuntu 20.04 LTS OS Login
   } 
}

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
    image_id      = "fd88jdvngivc0n3vuoq7" # Ubuntu 20.04 LTS OS Login
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
    image_id      = "fd88jdvngivc0n3vuoq7" # Ubuntu 20.04 LTS OS Login
  }
]
```

4.  Для включения зависимости от создания других виртуалок используем конструкцию

```
  # Выставляем зависимость от main и replica
  depends_on = [
    yandex_compute_instance.backend_vm["main"],
    yandex_compute_instance.backend_vm["replica"]
  ]
```

5.  Используем конструкцию

```
  metadata = {
    ssh-keys = "ubuntu:${file(var.ssh-key_path)}"
  }
```

где var.ssh-key_path описан в variables.tf, а значение берет из personal.auto.tfvars

6.  Еще добавим [outputs.tf](!!!), чтобы видеть внешние IP адреса.  
    Результат:
    
```
terraform apply -auto-approve

# Куча текста

Apply complete! Resources: 7 added, 0 changed, 0 destroyed.

Outputs:

all_vm_public_ips = {
  "main" = "89.169.156.248"
  "replica" = "84.201.128.124"
  "web-1" = "158.160.50.127"
  "web-2" = "89.169.148.168"
}
```

### Задание 3

1.  Создайте 3 одинаковых виртуальных диска размером 1 Гб с помощью ресурса yandex_compute_disk и мета-аргумента count в файле disk_vm.tf .
2.  Создайте в том же файле одиночную(использовать count или for_each запрещено из-за задания №4) ВМ c именем "storage" . Используйте блок dynamic secondary_disk{..} и мета-аргумент for_each для подключения созданных вами дополнительных дисков.

#### Решение

Конфигурация в [disk_vm.tf](!!!)

```
terraform apply -auto-approve

# Куча текста

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

Outputs:

all_vm_public_ips = {
  "main" = "158.160.101.12"
  "replica" = "51.250.71.183"
  "storage" = "158.160.126.92"
  "web-1" = "158.160.105.202"
  "web-2" = "158.160.121.68"
}
```

```
ubuntu@fhmig4rlo0i4cftihpp3:~$ lsblk
NAME    MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
vda     252:0    0   10G  0 disk 
├─vda1  252:1    0  9.4G  0 part /
├─vda14 252:14   0    4M  0 part 
└─vda15 252:15   0  600M  0 part /boot/efi
vdb     252:16   0    1G  0 disk 
vdc     252:32   0    1G  0 disk 
vdd     252:48   0    1G  0 disk 
```

### Задание 4

1.  В файле ansible.tf создайте inventory-файл для ansible. Используйте функцию tepmplatefile и файл-шаблон для создания ansible inventory-файла из лекции. Готовый код возьмите из демонстрации к лекции demonstration2. Передайте в него в качестве переменных группы виртуальных машин из задания 2.1, 2.2 и 3.2, т. е. 5 ВМ.
2.  Инвентарь должен содержать 3 группы и быть динамическим, т. е. обработать как группу из 2-х ВМ, так и 999 ВМ.
3.  Добавьте в инвентарь переменную fqdn.

```
[webservers]
web-1 ansible_host=<внешний ip-адрес> fqdn=<полное доменное имя виртуальной машины>
web-2 ansible_host=<внешний ip-адрес> fqdn=<полное доменное имя виртуальной машины>

[databases]
main ansible_host=<внешний ip-адрес> fqdn=<полное доменное имя виртуальной машины>
replica ansible_host<внешний ip-адрес> fqdn=<полное доменное имя виртуальной машины>

[storage]
storage ansible_host=<внешний ip-адрес> fqdn=<полное доменное имя виртуальной машины>
```

Пример fqdn:  
  web1.ru-central1.internal (в случае указания переменной hostname (не путать с переменной name));  
  fhm8k1oojmm5lie8i22a.auto.internal (в случае отсутвия перменной hostname - автоматическая генерация имени, зона изменяется на auto);  
  нужную вам переменную найдите в документации провайдера или terraform console;  
4.  Выполните код. Приложите скриншот получившегося файла.
Для общего зачёта создайте в вашем GitHub-репозитории новую ветку terraform-03. Закоммитьте в эту ветку свой финальный код проекта, пришлите ссылку на коммит.
Удалите все созданные ресурсы.

#### Решение

Создаем [ansible.tf](!!!) и [ansible.tftpl], правим [outputs.tf](!!!)

```
terraform apply -auto-approve

# Куча текста

Apply complete! Resources: 12 added, 0 changed, 0 destroyed.

Outputs:

ansible_inventory = <<EOT
[web]
web-1 ansible_host=84.201.173.161 fqdn=fhm64ib81qd5bjc5g6e2.auto.internal
web-2 ansible_host=158.160.112.120 fqdn=fhm7h358apvq6075j6p3.auto.internal

[main]
main ansible_host=158.160.126.68 fqdn=fhm1sbsci1d74o2tgf21.auto.internal

[replica]
replica ansible_host=158.160.99.86 fqdn=fhmeesks9oap9i5e57gj.auto.internal

[storage]
storage ansible_host=51.250.77.49 fqdn=fhmj8ms1qn3fdj587f6b.auto.internal

EOT
vms_public_ips = {
  "main" = "158.160.126.68"
  "replica" = "158.160.99.86"
  "storage" = "51.250.77.49"
  "web-1" = "84.201.173.161"
  "web-2" = "158.160.112.120"
}
```

Ссылка на [inventory_backup.ini](!!!)



