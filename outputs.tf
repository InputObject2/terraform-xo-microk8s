output "kubeconfig" {
  value = sshcommand_command.get_kubeconfig.result
}

output "master_ips" {
  value = concat([xenorchestra_vm.master.ipv4_addresses[0]], xenorchestra_vm.secondary[*].ipv4_addresses[0])
}

output "node_ips" {
  value = xenorchestra_vm.node[*].ipv4_addresses[0]
}

output "master_hostnames" {
  value = concat([xenorchestra_vm.master.name_description], xenorchestra_vm.secondary[*].name_description)
}

output "node_hostnames" {
  value = xenorchestra_vm.node[*].name_description
}

output "primary_master_ip" {
  value = xenorchestra_vm.master.ipv4_addresses[0]
}

output "primary_master_hostname" {
  value = xenorchestra_vm.master.name_description
}