output "kubeconfig" {
  description = "The kubeconfig file content for the provisioned MicroK8s cluster."
  value       = sshcommand_command.get_kubeconfig.result
}

output "master_ips" {
  description = "List of IPv4 addresses for all master nodes (primary first, then secondaries)."
  value       = concat([xenorchestra_vm.master.ipv4_addresses[0]], xenorchestra_vm.secondary[*].ipv4_addresses[0])
}

output "node_ips" {
  description = "List of IPv4 addresses for all worker nodes."
  value       = xenorchestra_vm.node[*].ipv4_addresses[0]
}

output "master_hostnames" {
  description = "List of hostnames for all master nodes (primary first, then secondaries)."
  value       = concat([xenorchestra_vm.master.name_description], xenorchestra_vm.secondary[*].name_description)
}

output "node_hostnames" {
  description = "List of hostnames for all worker nodes."
  value       = xenorchestra_vm.node[*].name_description
}

output "primary_master_ip" {
  description = "IPv4 address of the primary master node."
  value       = xenorchestra_vm.master.ipv4_addresses[0]
}

output "primary_master_hostname" {
  description = "Hostname of the primary master node."
  value       = xenorchestra_vm.master.name_description
}

output "master_mac_addresses" {
  description = "Effective MAC addresses used for master node NICs (index 0 = primary, 1..N-1 = secondaries)."
  value       = concat([local.effective_master_primary_mac], local.effective_master_secondary_macs)
}

output "node_mac_addresses" {
  description = "Effective MAC addresses used for worker node NICs."
  value       = local.effective_node_macs
}
