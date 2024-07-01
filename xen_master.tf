resource "random_integer" "master" {
  count = var.master_count
  min   = 1000
  max   = 9999
}

resource "random_uuid" "custom_token" {}

locals {
  # Generate a random UUID and extract the first 32 characters
  custom_token             = substr(random_uuid.custom_token.result, 0, 32)
  master_prefix            = "${var.master_prefix}-${var.cluster_name}-master"
  microk8s_version_channel = var.microk8s_version == null ? "" : "--channel=${var.microk8s_version}"
}

resource "xenorchestra_cloud_config" "master" {
  name     = "ubuntu-base-config-master-0-${var.cluster_name}"
  template = <<EOF
#cloud-config
hostname: "${local.master_prefix}-${random_integer.master[0].result}.${var.cluster_dns_zone}"
preserve_hostname: false

users:
  - name: cloud-user
    gecos: cloud-user
    shell: /bin/bash
    sudo: ALL=(ALL) NOPASSWD:ALL
    ssh_authorized_keys:
      - ${var.public_ssh_key}

packages:
  - xe-guest-utilities
  - open-iscsi
  - lsscsi
  - sg3-utils
  - multipath-tools
  - scsitools
  - cifs-utils
  - jq

write_files:
  - path: /tmp/k8s-image-swapper-values.yaml
    content: |
      config:
        dryRun: false
        logFormat: console
        logLevel: debug
        imageSwapPolicy: always
        imageCopyPolicy: immediate
        source:
          filters:
          - jmespath: obj.metadata.namespace == 'k8s-image-swapper'
        target:
          type: generic
          generic:
            repository: docker-private-registry.${substr(lower(var.dns_zone), 0, length(var.dns_zone) - 1)}

      image:
        repository: inputobject2/k8s-image-swapper
        pullPolicy: Always
        # Overrides the image tag whose default is the chart appVersion.
        tag: "v1.5.9-noauth"

      resources:
        limits:
          cpu: 2
          memory: 500Mi
        requests:
          cpu: 100m
          memory: 80Mi

runcmd:
  - |
    netplan apply
    snap install microk8s --classic ${local.microk8s_version_channel}
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
    microk8s add-node --token ${local.custom_token} --token-ttl 9999999
    microk8s status --wait-ready
    microk8s kubectl label node ${local.master_prefix}-${random_integer.master[0].result}.${var.dns_sub_zone}.${substr(lower(var.dns_zone), 0, length(var.dns_zone) - 1)} node-role.kubernetes.io/control-plane
    microk8s helm repo add estahn https://estahn.github.io/charts/
    microk8s helm repo update
    microk8s helm install k8s-image-swapper estahn/k8s-image-swapper -n k8s-image-swapper --create-namespace --version 1.8.0 -f /tmp/k8s-image-swapper-values.yaml
    microk8s enable metrics-server

firewall:
  rules:
    - name: Allow traffic on port 16443
      port: 16443
      protocol: tcp
      action: accept
      source: 0.0.0.0/0
    - name: Allow traffic on port 80
      port: 80
      protocol: tcp
      action: accept
      source: 0.0.0.0/0
    - name: Allow traffic on port 443
      port: 443
      protocol: tcp
      action: accept
      source: 0.0.0.0/0
    - name: Allow traffic on port 25000
      port: 25000
      protocol: tcp
      action: accept
      source: 0.0.0.0/0
    - name: Allow traffic on port 32000
      port: 32000
      protocol: tcp
      action: accept
      source: 0.0.0.0/0

power_state:
  delay: now
  mode: reboot
  message: Rebooting to make sure master is up
  timeout: 60
  condition: true

EOF
}


resource "xenorchestra_vm" "master" {

  name_label           = "${local.master_prefix}-${random_integer.master[0].result}"
  cloud_config         = xenorchestra_cloud_config.master.template
  cloud_network_config = var.cloud_network_config_template
  template             = var.master_xoa_template_uuid
  auto_poweron         = true

  name_description = "${local.master_prefix}-${random_integer.master[0].result}.${var.dns_sub_zone}.${substr(lower(var.dns_zone), 0, length(var.dns_zone) - 1)}"

  network {
    network_id  = data.xenorchestra_network.master.id
    mac_address = local.mac_address_list[random_integer.master[0].result]
  }

  disk {
    sr_id      = var.master_os_disk_xoa_sr_uuid[0]
    name_label = "${local.master_prefix}-${random_integer.master[0].result}-os"
    size       = var.master_os_disk_size * 1024 * 1024 * 1024 # GB to B
  }

  cpus       = var.master_cpu_count
  memory_max = var.master_memory_gb * 1024 * 1024 * 1024 # GB to B

  wait_for_ip = true
  start_delay = var.start_delay

  tags = concat(var.tags, var.master_tags, ["kubernetes.io/role:primary", "xcp-ng.org/deployment:${var.cluster_name}"])

  lifecycle {
    ignore_changes = [disk, affinity_host, template]
  }
}

resource "null_resource" "sleep_while_master_readies_up" {
  provisioner "local-exec" {
    command = "sleep 240" # Sleep to until master is ready
  }

  depends_on = [xenorchestra_vm.master]
}

resource "sshcommand_command" "get_kubeconfig" {
  host        = xenorchestra_vm.master.ipv4_addresses[0]
  command     = "sudo microk8s config get"
  private_key = file(var.private_ssh_key_path)
  user        = "cloud-user"

  depends_on = [null_resource.sleep_while_master_readies_up]
}