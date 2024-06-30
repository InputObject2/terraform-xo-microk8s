# terraform-xo-microk8s
This repository contains a Terraform module designed to deploy virtual machines that form a MicroK8s cluster using Xen-Orchestra. It creates a 3-node cluster by default but more nodes can be added dynamically.

# Example usage

```bash
module "microk8s_cluster" {
  source = "../"

  # Node settings
  node_count               = 0
  node_prefix              = "us20-k8s"
  node_cpu_count           = 2
  node_memory_gb           = 4
  node_os_disk_size        = 10
  node_os_disk_xoa_sr_uuid = ["f5476a1f-03ad-f4fb-ed42-82397ff9a211"]
  node_xoa_template_uuid   = "5cd9d957-fc99-cb17-7550-777204797183"

  # Master settings
  master_count               = 3
  master_prefix              = "us20-k8s"
  master_cpu_count           = 8
  master_memory_gb           = 8
  master_os_disk_size        = 10
  master_os_disk_xoa_sr_uuid = ["cf62bbaf-8107-19cb-9b8c-62cbf28d2f52"]
  master_xoa_template_uuid   = "499cad8b-dff9-cfa9-cc18-719184d85747"

  # Xen Orchestra settings can be set via environment variables
  #xoa_username => XOA_USERNAME
  #xoa_password => XOA_PASSWORD
  #xoa_ignore_ssl => XOA_IGNORE_SSL
  #xoa_api_url => XOA_API_URL

  xoa_pool_name         = "my-xcp-ng-pool"
  xoa_network_name      = "[95] Kubernetes"
  start_delay           = 0

  # Other settings
  public_ssh_key   = "ssh-rsa AAAAB3N..."

  dns_zone         = "example.com."
  dns_sub_zone     = "k8s"
  cluster_dns_zone = "k8s.example.com."
  cluster_name     = "cluster"
}
```