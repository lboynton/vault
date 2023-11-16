# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: BUSL-1.1

terraform {
  required_providers {
    enos = {
      source = "app.terraform.io/hashicorp-qti/enos"
    }
  }
}

variable "hosts" {
  type = map(object({
    private_ip = string
    public_ip  = string
  }))
  description = "The hosts for whom default softhsm configuration will be applied"
}

variable "skip" {
  type        = bool
  default     = false
  description = "Whether or not to skip initializing softhsm"
}

locals {
  // The location on disk to write the softhsm tokens to
  token_dir = "/var/lib/softhsm/tokens"
}

resource "enos_remote_exec" "init_softhsm" {
  for_each = var.hosts

  environment = {
    TOKEN_DIR = local.token_dir
    SKIP      = var.skip ? "true" : "false"
  }

  scripts = [abspath("${path.module}/scripts/init-softhsm.sh")]

  transport = {
    ssh = {
      host = each.value.public_ip
    }
  }
}

output "token_dir" {
  value = local.token_dir
}

output "skipped" {
  value = var.skip
}
