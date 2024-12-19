locals {
  node_prefix = "${var.node_prefix}-${var.cluster_name}-node"
}

resource "random_integer" "node" {
  count = var.node_count
  min   = 1000
  max   = 9999
}

resource "macaddress" "mac_nodes" {
  count  = var.node_count
  prefix = [0, 22, 62]

  lifecycle {
    ignore_changes = [prefix]
  }

}

resource "xenorchestra_cloud_config" "node" {
  count    = var.node_count
  name     = "ubuntu-base-config-node-${count.index}"
  template = <<EOF
#cloud-config
hostname: "${local.node_prefix}-${random_integer.node[count.index].result}.${var.dns_sub_zone}.${lower(var.dns_zone)}"

users:
  - name: cloud-user
    gecos: cloud-user
    shell: /bin/bash
    sudo: ALL=(ALL) NOPASSWD:ALL
    ssh_authorized_keys:
      - ${var.public_ssh_key}

packages:
  - open-iscsi
  - lsscsi
  - sg3-utils
  - multipath-tools
  - scsitools
  - cifs-utils
  - jq

runcmd:
  - wget https://github.com/xenserver/xe-guest-utilities/releases/download/v8.4.0/xe-guest-utilities_8.4.0-1_amd64.deb
  - dpkg -i xe-guest-utilities_8.4.0-1_amd64.deb
  - |
    netplan apply
    snap install microk8s --classic
    ufw allow in on cni0 && sudo ufw allow out on cni0
    ufw default allow routed

    sudo tee /etc/multipath.conf <<-'EOD'
    defaults {
        user_friendly_names yes
        find_multipaths yes
    }
    EOD

    systemctl enable multipath-tools.service
    systemctl restart multipath-tools
    systemctl enable open-iscsi.service
    systemctl restart open-iscsi

    microk8s start
    microk8s join ${xenorchestra_vm.master.ipv4_addresses[0]}:25000/${local.custom_token} --worker
    microk8s kubectl label node ${local.node_prefix}-${random_integer.node[count.index].result}.${var.dns_sub_zone}.${substr(lower(var.dns_zone), 0, length(var.dns_zone) - 1)} node-role.kubernetes.io/worker=worker
EOF

  depends_on = [xenorchestra_vm.master]
}

resource "xenorchestra_vm" "node" {
  count = var.node_count

  name_label           = "${local.node_prefix}-${random_integer.node[count.index].result}"
  cloud_config         = xenorchestra_cloud_config.node[count.index].template
  cloud_network_config = var.cloud_network_config_template
  template             = var.node_xoa_template_uuid
  auto_poweron         = true

  name_description = "${local.node_prefix}-${random_integer.node[count.index].result}.${var.dns_sub_zone}.${substr(lower(var.dns_zone), 0, length(var.dns_zone) - 1)}"

  network {
    network_id       = data.xenorchestra_network.node.id
    mac_address      = macaddress.mac_nodes[count.index].address
    expected_ip_cidr = var.node_expected_cidr
  }

  disk {
    sr_id      = var.node_os_disk_xoa_sr_uuid[count.index % length(var.node_os_disk_xoa_sr_uuid)]
    name_label = "${local.node_prefix}-${random_integer.node[count.index].result}-os"
    size       = var.node_os_disk_size * 1024 * 1024 * 1024 # GB to B
  }

  cpus       = var.node_cpu_count
  memory_max = var.node_memory_gb * 1024 * 1024 * 1024 # GB to B

  start_delay                         = var.start_delay
  destroy_cloud_config_vdi_after_boot = false

  tags = concat(var.tags, var.node_tags, ["kubernetes.io/role:worker", "xcp-ng.org/deployment:${var.cluster_name}"])

  lifecycle {
    ignore_changes = [disk, affinity_host, template]
  }

  depends_on = [xenorchestra_vm.master, null_resource.sleep_while_master_readies_up, xenorchestra_vm.secondary]
}
