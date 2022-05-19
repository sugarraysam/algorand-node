# AMI Builder (EBS backed) https://www.packer.io/plugins/builders/amazon/ebs
source "amazon-ebs" "algorand" {
  access_key      = var.aws_access_key
  secret_key      = var.aws_secret_key
  region          = var.aws_region
  ami_name        = var.dst_ami
  ami_description = "Ubuntu based algorand node. Built by Packer."
  ami_groups      = ["all"] # makes AMI public
  instance_type   = var.instance_type
  source_ami      = var.src_ami

  # https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/connection-prereqs.html
  # There is a bug with RSA temporary keys
  ssh_username            = "ubuntu"
  temporary_key_pair_type = "ed25519"
  ssh_agent_auth          = false

  # Overwrite AMI and snapshots if they already exist
  force_deregister      = true
  force_delete_snapshot = true
}

locals {
  cloud_init_cfg_path = "/tmp/10_firstboot.cfg"
}

build {
  sources = ["source.amazon-ebs.algorand"]

  provisioner "file" {
    destination = local.cloud_init_cfg_path
    source      = "${path.root}/10_firstboot.cfg"
  }

  # Wait for cloud-init process to fully finish
  # https://www.packer.io/docs/debugging#issues-installing-ubuntu-packages
  provisioner "shell" {
    inline = ["cloud-init status --wait"]
  }

  # Algorand dev documentation:
  # https://developer.algorand.org/docs/run-a-node/setup/install/#installation-with-a-package-manager
  provisioner "shell" {
    environment_vars = [
      "ALGORAND_DATA=/var/lib/algorand",
    ]

    inline = [
      # Remove debconf warnings
      # https://github.com/moby/moby/issues/27988
      "echo 'debconf debconf/frontend select Noninteractive' | sudo debconf-set-selections",
      #
      # Install packages
      #
      "sudo apt-get update",
      "sudo apt-get install -y gnupg2 curl software-properties-common",
      "curl -L https://releases.algorand.com/key.pub | sudo apt-key add -",
      "sudo add-apt-repository -y 'deb [arch=amd64] https://releases.algorand.com/deb/ stable main'",
      "sudo apt-get update",
      #
      # Install algorand and devtools
      # - Creates an algorand user and group (the user does not have a login)
      # - Creates an algorand.service to be ran with systemd (prevent automatic start)
      #
      "sudo ln -s /dev/null /etc/systemd/system/algorand.service",
      "sudo apt-get install -y algorand-devtools",
      "algod -v",
      "goal --version",
      #
      # Setup cloud-init for first boot
      #
      "cat ${local.cloud_init_cfg_path} | sudo tee -a /etc/cloud/cloud.cfg.d/10_firstboot.cfg",
      "rm ${local.cloud_init_cfg_path}",
      #
      # Configure ubuntu user
      #
      "sudo usermod -a -G algorand ubuntu",
      "echo 'export ALGORAND_DATA=/var/lib/algorand' >> ~/.bashrc"
      #
      # TODO: configure unattended upgrades + email notifications
      #
    ]
  }
}
