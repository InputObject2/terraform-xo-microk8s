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

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_macaddress"></a> [macaddress](#requirement\_macaddress) | >=0.3.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >=3.2.3 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >=3.6.3 |
| <a name="requirement_sshcommand"></a> [sshcommand](#requirement\_sshcommand) | >=0.2.2 |
| <a name="requirement_xenorchestra"></a> [xenorchestra](#requirement\_xenorchestra) | 0.29.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_macaddress"></a> [macaddress](#provider\_macaddress) | 0.3.2 |
| <a name="provider_null"></a> [null](#provider\_null) | 3.2.3 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.6.3 |
| <a name="provider_sshcommand"></a> [sshcommand](#provider\_sshcommand) | 0.2.2 |
| <a name="provider_xenorchestra"></a> [xenorchestra](#provider\_xenorchestra) | 0.29.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [macaddress_macaddress.mac_master_primary](https://registry.terraform.io/providers/ivoronin/macaddress/latest/docs/resources/macaddress) | resource |
| [macaddress_macaddress.mac_master_secondaries](https://registry.terraform.io/providers/ivoronin/macaddress/latest/docs/resources/macaddress) | resource |
| [macaddress_macaddress.mac_nodes](https://registry.terraform.io/providers/ivoronin/macaddress/latest/docs/resources/macaddress) | resource |
| [null_resource.sleep_while_master_readies_up](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [random_integer.master](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/integer) | resource |
| [random_integer.node](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/integer) | resource |
| [random_uuid.custom_token](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/uuid) | resource |
| [sshcommand_command.get_kubeconfig](https://registry.terraform.io/providers/invidian/sshcommand/latest/docs/resources/command) | resource |
| [xenorchestra_cloud_config.master](https://registry.terraform.io/providers/vatesfr/xenorchestra/0.29.0/docs/resources/cloud_config) | resource |
| [xenorchestra_cloud_config.node](https://registry.terraform.io/providers/vatesfr/xenorchestra/0.29.0/docs/resources/cloud_config) | resource |
| [xenorchestra_cloud_config.secondary](https://registry.terraform.io/providers/vatesfr/xenorchestra/0.29.0/docs/resources/cloud_config) | resource |
| [xenorchestra_vm.master](https://registry.terraform.io/providers/vatesfr/xenorchestra/0.29.0/docs/resources/vm) | resource |
| [xenorchestra_vm.node](https://registry.terraform.io/providers/vatesfr/xenorchestra/0.29.0/docs/resources/vm) | resource |
| [xenorchestra_vm.secondary](https://registry.terraform.io/providers/vatesfr/xenorchestra/0.29.0/docs/resources/vm) | resource |
| [xenorchestra_network.master](https://registry.terraform.io/providers/vatesfr/xenorchestra/0.29.0/docs/data-sources/network) | data source |
| [xenorchestra_network.node](https://registry.terraform.io/providers/vatesfr/xenorchestra/0.29.0/docs/data-sources/network) | data source |
| [xenorchestra_pool.xcp_ng_master](https://registry.terraform.io/providers/vatesfr/xenorchestra/0.29.0/docs/data-sources/pool) | data source |
| [xenorchestra_pool.xcp_ng_node](https://registry.terraform.io/providers/vatesfr/xenorchestra/0.29.0/docs/data-sources/pool) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloud_network_config_template"></a> [cloud\_network\_config\_template](#input\_cloud\_network\_config\_template) | Template for cloud network config | `string` | `"network:\r\n  version: 1\r\n  config:\r\n  - type: physical\r\n    name: eth0\r\n    subnets:\r\n    - type: dhcp\r\n"` | no |
| <a name="input_cluster_dns_zone"></a> [cluster\_dns\_zone](#input\_cluster\_dns\_zone) | DNS zone for the cluster | `string` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name used in the virtual machine names, not an actual Kubernetes settings | `string` | `"my-cluster"` | no |
| <a name="input_dns_sub_zone"></a> [dns\_sub\_zone](#input\_dns\_sub\_zone) | DNS sub-zone | `string` | n/a | yes |
| <a name="input_dns_zone"></a> [dns\_zone](#input\_dns\_zone) | DNS zone | `string` | n/a | yes |
| <a name="input_install_k8s_image_swapper"></a> [install\_k8s\_image\_swapper](#input\_install\_k8s\_image\_swapper) | This will add the chart by default to use the k8s-image-swapper and save on imagePulls to Dockerhub, which are rate-limited | `bool` | `false` | no |
| <a name="input_k8s_image_swapper_private_registy"></a> [k8s\_image\_swapper\_private\_registy](#input\_k8s\_image\_swapper\_private\_registy) | Point this to the FQDN of a private registry so the k8s-image-swapper can pull from there. Has no effect if `install_k8s_image_swapper` is unused | `string` | `""` | no |
| <a name="input_master_count"></a> [master\_count](#input\_master\_count) | Number of master nodes to deploy | `number` | `3` | no |
| <a name="input_master_cpu_count"></a> [master\_cpu\_count](#input\_master\_cpu\_count) | Number of CPUs for each master node | `number` | `2` | no |
| <a name="input_master_expected_cidr"></a> [master\_expected\_cidr](#input\_master\_expected\_cidr) | Expected CIDR for master nodes, used for checking if the virtual machine is now ready. Replaces the old `wait_for_ip` | `string` | `"10.0.0.0/16"` | no |
| <a name="input_master_memory_gb"></a> [master\_memory\_gb](#input\_master\_memory\_gb) | Memory in GB for each master node | `number` | `4` | no |
| <a name="input_master_os_disk_size"></a> [master\_os\_disk\_size](#input\_master\_os\_disk\_size) | OS disk size in GB for each master node | `number` | `32` | no |
| <a name="input_master_os_disk_xoa_sr_uuid"></a> [master\_os\_disk\_xoa\_sr\_uuid](#input\_master\_os\_disk\_xoa\_sr\_uuid) | Storage repository UUID for master node OS disks | `list(string)` | n/a | yes |
| <a name="input_master_prefix"></a> [master\_prefix](#input\_master\_prefix) | Prefix for master node names | `string` | `"us20-k8s"` | no |
| <a name="input_master_tags"></a> [master\_tags](#input\_master\_tags) | Tags to apply to master nodes | `list(string)` | <pre>[<br>  "xcp-ng.org/arch:amd64",<br>  "xcp-ng.org/os:ubuntu"<br>]</pre> | no |
| <a name="input_master_xoa_network_name"></a> [master\_xoa\_network\_name](#input\_master\_xoa\_network\_name) | Network name for master nodes in Xen Orchestra (overrides `xoa_network_name`) | `string` | `null` | no |
| <a name="input_master_xoa_pool_name"></a> [master\_xoa\_pool\_name](#input\_master\_xoa\_pool\_name) | Name of the Xen Orchestra pool for master nodes (overrides `xoa_pool_name` for masters) | `string` | `null` | no |
| <a name="input_master_xoa_template_uuid"></a> [master\_xoa\_template\_uuid](#input\_master\_xoa\_template\_uuid) | Template UUID for master nodes in Xen Orchestra | `string` | n/a | yes |
| <a name="input_microk8s_version"></a> [microk8s\_version](#input\_microk8s\_version) | The snap channel version to install, for example `1.29/stable`. Defaults to latest if not specified | `string` | `null` | no |
| <a name="input_node_count"></a> [node\_count](#input\_node\_count) | Number of worker nodes to deploy | `number` | `0` | no |
| <a name="input_node_cpu_count"></a> [node\_cpu\_count](#input\_node\_cpu\_count) | Number of CPUs for each worker node | `number` | `4` | no |
| <a name="input_node_expected_cidr"></a> [node\_expected\_cidr](#input\_node\_expected\_cidr) | Expected CIDR for nodes, used for checking if the virtual machine is now ready. Replaces the old `wait_for_ip` | `string` | `"10.0.0.0/16"` | no |
| <a name="input_node_memory_gb"></a> [node\_memory\_gb](#input\_node\_memory\_gb) | Memory in GB for each worker node | `number` | `8` | no |
| <a name="input_node_os_disk_size"></a> [node\_os\_disk\_size](#input\_node\_os\_disk\_size) | OS disk size in GB for each worker node | `number` | `32` | no |
| <a name="input_node_os_disk_xoa_sr_uuid"></a> [node\_os\_disk\_xoa\_sr\_uuid](#input\_node\_os\_disk\_xoa\_sr\_uuid) | Storage repository UUID for worker node OS disks | `list(string)` | n/a | yes |
| <a name="input_node_prefix"></a> [node\_prefix](#input\_node\_prefix) | Prefix for worker node names | `string` | `"us20-k8s"` | no |
| <a name="input_node_tags"></a> [node\_tags](#input\_node\_tags) | Tags to apply to worker nodes | `list(string)` | <pre>[<br>  "xcp-ng.org/arch:amd64",<br>  "xcp-ng.org/os:ubuntu"<br>]</pre> | no |
| <a name="input_node_xoa_network_name"></a> [node\_xoa\_network\_name](#input\_node\_xoa\_network\_name) | Network name for worker nodes in Xen Orchestra (overrides `xoa_network_name`) | `string` | `null` | no |
| <a name="input_node_xoa_pool_name"></a> [node\_xoa\_pool\_name](#input\_node\_xoa\_pool\_name) | Name of the Xen Orchestra pool for worker nodes (overrides `xoa_pool_name` for nodes) | `string` | `null` | no |
| <a name="input_node_xoa_template_uuid"></a> [node\_xoa\_template\_uuid](#input\_node\_xoa\_template\_uuid) | Template UUID for worker nodes in Xen Orchestra | `string` | n/a | yes |
| <a name="input_private_ssh_key_path"></a> [private\_ssh\_key\_path](#input\_private\_ssh\_key\_path) | Private SSH key path for accessing the nodes | `string` | `"/root/.ssh/id_rsa"` | no |
| <a name="input_public_ssh_key"></a> [public\_ssh\_key](#input\_public\_ssh\_key) | Public SSH key for accessing the nodes | `string` | n/a | yes |
| <a name="input_start_delay"></a> [start\_delay](#input\_start\_delay) | The amount of time the cluster virtual machines will wait on XCP-NG host startup | `number` | `0` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A list of key+value pairs to apply to the deployment | `list(string)` | `[]` | no |
| <a name="input_xoa_network_name"></a> [xoa\_network\_name](#input\_xoa\_network\_name) | Default network for virtual machines as seen in Xen Orchestra | `string` | `null` | no |
| <a name="input_xoa_pool_name"></a> [xoa\_pool\_name](#input\_xoa\_pool\_name) | Default name of the XCP-ng pool as seen in Xen Orchestra | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kubeconfig"></a> [kubeconfig](#output\_kubeconfig) | n/a |
| <a name="output_master_hostnames"></a> [master\_hostnames](#output\_master\_hostnames) | n/a |
| <a name="output_master_ips"></a> [master\_ips](#output\_master\_ips) | n/a |
| <a name="output_node_hostnames"></a> [node\_hostnames](#output\_node\_hostnames) | n/a |
| <a name="output_node_ips"></a> [node\_ips](#output\_node\_ips) | n/a |
| <a name="output_primary_master_hostname"></a> [primary\_master\_hostname](#output\_primary\_master\_hostname) | n/a |
| <a name="output_primary_master_ip"></a> [primary\_master\_ip](#output\_primary\_master\_ip) | n/a |
<!-- END_TF_DOCS -->

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
