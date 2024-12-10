# Node Settings
variable "node_count" {
  description = "Number of worker nodes to deploy"
  type        = number
  default     = 0
}

variable "node_prefix" {
  description = "Prefix for worker node names"
  type        = string
  default     = "us20-k8s"
}

variable "node_cpu_count" {
  description = "Number of CPUs for each worker node"
  type        = number
  default     = 4
}

variable "node_memory_gb" {
  description = "Memory in GB for each worker node"
  type        = number
  default     = 8
}

variable "node_os_disk_size" {
  description = "OS disk size in GB for each worker node"
  type        = number
  default     = 32
}

variable "node_os_disk_xoa_sr_uuid" {
  description = "Storage repository UUID for worker node OS disks"
  type        = list(string)
}

variable "node_xoa_template_uuid" {
  description = "Template UUID for worker nodes in Xen Orchestra"
  type        = string
}

variable "node_xoa_network_name" {
  description = "Network name for worker nodes in Xen Orchestra (overrides `xoa_network_name`)"
  type        = string
  default     = null
}

variable "node_expected_cidr" {
  description = "Expected CIDR for nodes, used for checking if the virtual machine is now ready. Replaces the old `wait_for_ip`"
  type        = string
  default     = "10.0.0.0/16"
}

variable "node_tags" {
  description = "Tags to apply to worker nodes"
  type        = list(string)
  default = [
    "xcp-ng.org/arch:amd64",
    "xcp-ng.org/os:ubuntu"
  ]
}

# Master Settings
variable "master_count" {
  description = "Number of master nodes to deploy"
  type        = number
  default     = 3
}

variable "master_prefix" {
  description = "Prefix for master node names"
  type        = string
  default     = "us20-k8s"
}

variable "master_cpu_count" {
  description = "Number of CPUs for each master node"
  type        = number
  default     = 2
}

variable "master_memory_gb" {
  description = "Memory in GB for each master node"
  type        = number
  default     = 4
}

variable "master_os_disk_size" {
  description = "OS disk size in GB for each master node"
  type        = number
  default     = 32
}

variable "master_os_disk_xoa_sr_uuid" {
  description = "Storage repository UUID for master node OS disks"
  type        = list(string)
}

variable "master_xoa_template_uuid" {
  description = "Template UUID for master nodes in Xen Orchestra"
  type        = string
}

variable "master_xoa_network_name" {
  description = "Network name for master nodes in Xen Orchestra (overrides `xoa_network_name`)"
  type        = string
  default     = null
}

variable "master_expected_cidr" {
  description = "Expected CIDR for master nodes, used for checking if the virtual machine is now ready. Replaces the old `wait_for_ip`"
  type        = string
  default     = "10.0.0.0/16"
}

variable "master_tags" {
  description = "Tags to apply to master nodes"
  type        = list(string)
  default = [
    "xcp-ng.org/arch:amd64",
    "xcp-ng.org/os:ubuntu"
  ]
}

# Xen Orchestra Settings
variable "xoa_api_url" {
  description = "URL for Xen Orchestra API (can be set via XOA_API_URL environment variable)"
  type        = string
}

variable "xoa_pool_name" {
  description = "Default name of the XCP-ng pool as seen in Xen Orchestra"
  type        = string
  default     = null
}

variable "xoa_network_name" {
  description = "Default network for virtual machines as seen in Xen Orchestra"
  type        = string
  default     = null
}

variable "master_xoa_pool_name" {
  description = "Name of the Xen Orchestra pool for master nodes (overrides `xoa_pool_name` for masters)"
  type        = string
  default     = null
}

variable "node_xoa_pool_name" {
  description = "Name of the Xen Orchestra pool for worker nodes (overrides `xoa_pool_name` for nodes)"
  type        = string
  default     = null
}

variable "xoa_username" {
  description = "Username for Xen Orchestra API (can be set via XOA_USERNAME environment variable)"
  type        = string
  default     = null
}

variable "xoa_password" {
  description = "Password for Xen Orchestra API (can be set via XOA_PASSWORD environment variable)"
  type        = string
  default     = null
}

variable "xoa_ignore_ssl" {
  description = "Ignore SSL verification for Xen Orchestra API (can be set via XOA_IGNORE_SSL environment variable)"
  type        = bool
  default     = null
}

variable "start_delay" {
  description = "The amount of time the cluster virtual machines will wait on XCP-NG host startup"
  type        = number
  default     = 0
}

# Other Settings
variable "cluster_dns_zone" {
  description = "DNS zone for the cluster"
  type        = string
}

variable "public_ssh_key" {
  description = "Public SSH key for accessing the nodes"
  type        = string
}

variable "private_ssh_key_path" {
  description = "Private SSH key path for accessing the nodes"
  type        = string
  default     = "/root/.ssh/id_rsa"
}

variable "dns_zone" {
  description = "DNS zone"
  type        = string
}

variable "dns_sub_zone" {
  description = "DNS sub-zone"
  type        = string
}

variable "cluster_name" {
  description = "Name used in the virtual machine names, not an actual Kubernetes settings"
  type        = string
  default     = "my-cluster"
}

variable "microk8s_version" {
  description = "The snap channel version to install, for example `1.29/stable`. Defaults to latest if not specified"
  type        = string
  default     = null
}

variable "install_k8s_image_swapper" {
  description = "This will add the chart by default to use the k8s-image-swapper and save on imagePulls to Dockerhub, which are rate-limited"
  type        = bool
  default     = false
}

variable "k8s_image_swapper_private_registy" {
  description = "Point this to the FQDN of a private registry so the k8s-image-swapper can pull from there. Has no effect if `install_k8s_image_swapper` is unused"
  type        = string
  default     = ""
}

variable "cloud_network_config_template" {
  description = "Template for cloud network config"
  type        = string
  default     = <<EOF
network:
  version: 1
  config:
  - type: physical
    name: eth0
    subnets:
    - type: dhcp
EOF
}

variable "tags" {
  description = "A list of key+value pairs to apply to the deployment"
  type        = list(string)
  default     = []
}