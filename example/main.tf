module "microk8s_cluster" {
  #source = "git@github.com:InputObject2/terraform-xo-microk8s.git"

  source = "../"
  # Node settings
  node_count               = 3
  node_prefix              = "node"
  node_cpu_count           = 2
  node_memory_gb           = 4
  node_os_disk_size        = 10
  node_os_disk_xoa_sr_uuid = ["xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"]
  node_xoa_template_uuid   = "yyyyyyyy-yyyy-yyyy-yyyy-yyyyyyyyyyyy"

  # Master settings
  master_count               = 3
  master_prefix              = "master"
  master_cpu_count           = 8
  master_memory_gb           = 8
  master_os_disk_size        = 10
  master_os_disk_xoa_sr_uuid = ["xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"]
  master_xoa_template_uuid   = "yyyyyyyy-yyyy-yyyy-yyyy-yyyyyyyyyyyy"

  # Xen Orchestra settings
  xoa_pool_name    = "my-pool"
  xoa_network_name = "my-network"
  start_delay      = 0

  # Other settings
  cluster_dns_zone = "k8s.example.com."
  public_ssh_key   = "ssh-rsa AAAAB3Nza..."

  dns_zone     = "example.com."
  dns_sub_zone = "k8s"
  cluster_name = "my-k8s-cluster"
}
