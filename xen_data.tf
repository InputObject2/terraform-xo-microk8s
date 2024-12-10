provider "xenorchestra" {
  # Configuration options
  # Must be ws or wss
  url      = var.xoa_api_url    # Or set XOA_URL environment variable
  username = var.xoa_username   # Or set XOA_USER environment variable
  password = var.xoa_password   # Or set XOA_PASSWORD environment variable
  insecure = var.xoa_ignore_ssl # Or set XOA_INSECURE environment variable to any value
}

provider "macaddress" {}


# docs : https://github.com/terra-farm/terraform-provider-xenorchestra/blob/master/docs/resources/vm.md

locals {
  master_pool_name = var.master_xoa_pool_name == null ? var.xoa_pool_name : var.master_xoa_pool_name
  node_pool_name   = var.node_xoa_pool_name == null ? var.xoa_pool_name : var.node_xoa_pool_name
  master_network   = var.master_xoa_network_name == null ? var.xoa_network_name : var.master_xoa_network_name
  node_network     = var.node_xoa_network_name == null ? var.xoa_network_name : var.node_xoa_network_name
}

data "xenorchestra_pool" "xcp_ng_master" {
  name_label = local.master_pool_name
}

data "xenorchestra_pool" "xcp_ng_node" {
  name_label = local.node_pool_name
}

data "xenorchestra_network" "master" {
  pool_id    = data.xenorchestra_pool.xcp_ng_master.id
  name_label = local.master_network
}

data "xenorchestra_network" "node" {
  pool_id    = data.xenorchestra_pool.xcp_ng_node.id
  name_label = local.node_network
}