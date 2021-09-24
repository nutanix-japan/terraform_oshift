terraform {
  required_providers {
    nutanix = {
      source  = "nutanix/nutanix"
      version = "1.2.0"
    }
  }
}

data "nutanix_cluster" "cluster" {
  name = var.cluster_name
}
data "nutanix_subnet" "subnet" {
  subnet_name = var.subnet_name
}

provider "nutanix" {
  username     = var.user
  password     = var.password
  endpoint     = var.endpoint
  insecure     = true
  wait_timeout = 60
}

resource "nutanix_image" "rhocs" {
  name        = "RHOCS"
  description = "RHOCS.iso"
  image_type = "ISO_IMAGE"
  source_uri  = "https://s3.us-east-1.amazonaws.com/assisted-installer/discovery-image-b1975412-0c4a-4518-aec8-3ff6551ed375.iso?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIA52ZYGBOVI2P2TOEQ%2F20210916%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20210916T044509Z&X-Amz-Expires=14400&X-Amz-SignedHeaders=host&response-content-disposition=attachment%3Bfilename%3Ddiscovery-image-b1975412-0c4a-4518-aec8-3ff6551ed375.iso&X-Amz-Signature=4197a7249d49e509daed07556d2bcc3ac00e31dc85b52483ee4d4999efa08551"
}

# resource "nutanix_image" "centos" {
#   name        = "centos"
#   description = "centos.qcow"
#   source_uri  = "https://mirror.openshift.com/pub/openshift-v4/dependencies/rhcos/latest/latest/rhcos-live.x86_64.iso"
# }

# data "template_file" "cloud" {
#     count = var.vm_count
#     template = file("cloud-init")
#     vars = {
#         vm_name = "${var.vm_name}-${count.index + 1}"
# 	      vm_domain = var.vm_domain
#     }
# }
# resource "nutanix_virtual_machine" "rhocs" {
#   count                = var.vm_count
#   name                 = "${var.vm_name}-${count.index + 1}"
#   cluster_uuid         = data.nutanix_cluster.cluster.id
#   num_vcpus_per_socket = "1"
#   num_sockets          = "4"
#   memory_size_mib      = 16*1024

#   disk_list {
#     device_properties {
#       device_type = "CDROM"
#       disk_address = {
#         "adapter_type" = "IDE"
#         "device_index" = "0"
#       }
#     }
#     data_source_reference = {
#       kind = "image"

#       uuid = nutanix_image.rhocs.id
#     }
#   }

# disk_list {
#   disk_size_bytes = 130 * 1024 * 1024 * 1024
#   device_properties {
#     device_type = "DISK"
#     disk_address = {
#       "adapter_type" = "SCSI"
#       "device_index" = "1"
#     }
#   }
# }

#   nic_list {
#     subnet_uuid = data.nutanix_subnet.subnet.id
#   }
# }
 
## Creating MASTER VMs here
resource "nutanix_virtual_machine" "rhocs-master" {
  count                = var.vm_master_count
  name                 = "${var.vm_master_prefix}-${count.index + 1}"
  cluster_uuid         = data.nutanix_cluster.cluster.id
  num_vcpus_per_socket = "1"
  num_sockets          = "4"
  memory_size_mib      = 16*1024

  disk_list {
    device_properties {
      device_type = "CDROM"
      disk_address = {
        "adapter_type" = "IDE"
        "device_index" = "0"
      }
    }
    data_source_reference = {
      kind = "image"

      uuid = nutanix_image.rhocs.id
    }
  }

disk_list {
  disk_size_bytes = 130 * 1024 * 1024 * 1024
  device_properties {
    device_type = "DISK"
    disk_address = {
      "adapter_type" = "SCSI"
      "device_index" = "1"
    }
  }
}

  nic_list {
    subnet_uuid = data.nutanix_subnet.subnet.id
  }
}

## Creating WORKER VMs here
resource "nutanix_virtual_machine" "rhocs-worker" {
  count                = var.vm_worker_count
  name                 = "${var.vm_worker_prefix}-${count.index + 1}"
  cluster_uuid         = data.nutanix_cluster.cluster.id
  num_vcpus_per_socket = "1"
  num_sockets          = "4"
  memory_size_mib      = 16*1024

  disk_list {
    device_properties {
      device_type = "CDROM"
      disk_address = {
        "adapter_type" = "IDE"
        "device_index" = "0"
      }
    }
    data_source_reference = {
      kind = "image"

      uuid = nutanix_image.rhocs.id
    }
  }

disk_list {
  disk_size_bytes = 130 * 1024 * 1024 * 1024
  device_properties {
    device_type = "DISK"
    disk_address = {
      "adapter_type" = "SCSI"
      "device_index" = "1"
    }
  }
}

  nic_list {
    subnet_uuid = data.nutanix_subnet.subnet.id
  }
}

