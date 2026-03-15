terraform {
  required_version = ">= 1.0"
  required_providers {
    xenorchestra = {
      source  = "vatesfr/xenorchestra"
      version = ">=0.37.3"
    }
    macaddress = {
      source  = "ivoronin/macaddress"
      version = ">=0.3.0"
    }
    sshcommand = {
      source  = "invidian/sshcommand"
      version = ">=0.2.2"
    }
    null = {
      source  = "hashicorp/null"
      version = ">=3.2.3"
    }
    random = {
      source  = "hashicorp/random"
      version = ">=3.6.3"
    }
  }
}
