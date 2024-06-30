# This file contains the Xen orchestra configuration for VM's.
# docs : https://github.com/terra-farm/terraform-provider-xenorchestra/blob/master/docs/resources/vm.md
terraform {
  required_providers {
    xenorchestra = {
      source  = "terra-farm/xenorchestra"
    }
    macaddress = {
      source = "ivoronin/macaddress"
      #version = "0.3.0"
    }
    gitlab = {
      source = "gitlabhq/gitlab"
      #version = "16.4.1"
    }
    sshcommand = {
      source = "invidian/sshcommand"
      #version = "0.2.2"
    }
  }
}
