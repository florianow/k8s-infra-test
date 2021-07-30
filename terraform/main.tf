// Configure the Hetzner Cloud Provider
provider "hcloud" {
  token = var.hcloud_token
}
// Create a new SSH key
resource "hcloud_ssh_key" "default" {
  name       = "Terraform"
  public_key = file(var.public_key_path)
}

// Network configuration
resource "hcloud_network" "network" {
  name     = "network"
  ip_range = "10.10.0.0/24"
}

resource "hcloud_network_subnet" "sub" {
  network_id   = hcloud_network.network.id
  type         = "server"
  network_zone = "eu-central"
  ip_range     = "10.10.0.0/24"
}

 resource "hcloud_floating_ip" "master" {
   type = "ipv4"
   home_location = "nbg1"
 }

// cloud-init template
data "template_file" "user_data" {
  template = file("cloud-init.yml")
    vars = {
      pubkey = "${var.public_key}"
      user = "${var.ansible_user}"
  }
}

// Create a Master
resource "hcloud_server" "master" {
  count       = var.master_count
  name        = format("%s-%03d", var.server_name_master, count.index + 1)
  image       = var.image
  server_type = var.server_type_master
  ssh_keys    = [hcloud_ssh_key.default.name]
  user_data   = data.template_file.user_data.rendered
  connection {
    private_key = file(var.private_key_path)
    user        = var.ansible_user
    host        = self.ipv4_address
  }
  provisioner "local-exec" {
    command = <<EOT
    ansible-galaxy install -r ../ansible/roles/requirements.yml
    ansible-galaxy collection install -r ../ansible/collections/requirements.yml
    EOT
    }

}

// Create a Node
resource "hcloud_server" "node" {
  count       = var.node_count
  name        = format("%s-%03d", var.server_name_node, count.index + 1)
  image       = var.image
  server_type = var.server_type_node
  ssh_keys    = [hcloud_ssh_key.default.name]
  user_data   = data.template_file.user_data.rendered
  connection {
    private_key = file(var.private_key)
    user        = var.ansible_user
    host        = self.ipv4_address
  }
}

resource "hcloud_server_network" "network_master" {
  count      = var.master_count
  server_id  = element(hcloud_server.master.*.id, count.index)
  network_id = hcloud_network.network.id
  ip         = cidrhost(hcloud_network_subnet.sub.ip_range, count.index + 2)
}
resource "hcloud_server_network" "network_node" {
  count      = var.node_count
  server_id  = element(hcloud_server.node.*.id, count.index)
  network_id = hcloud_network.network.id
  ip         = cidrhost(hcloud_network_subnet.sub.ip_range, count.index + 10)
}

// The Ansible inventoryfile
resource "local_file" "AnsibleInventory" {
  content = templatefile("inventory.tmpl",

    {
      addrs-master = hcloud_server.master.*.ipv4_address
      name-master = hcloud_server.master.*.name
      ip-master = hcloud_server_network.network_master.*.ip
      addrs-node   = hcloud_server.node.*.ipv4_address
      name-node = hcloud_server.node.*.name
      ip-node = hcloud_server_network.network_node.*.ip
      float-ip = hcloud_floating_ip.master.ip_address
      privkey = "${var.private_key_path}"
      pubkey = "${var.public_key_path}"
      hcloud_token = "${var.hcloud_token}"
      user = "${var.ansible_user}"

  })

  filename = "${var.ansible_inventory}"
#TODO Blockbooks not used yet
# ansible-playbook -i ${var.ansible_inventory} ../ansible/playbooks/ansible_hardening.yml
# ansible-playbook -i ${var.ansible_inventory} ${var.known_hosts}
# ansible-playbook -i ${var.ansible_inventory} ${var.kubespray_path}mitogen.yml
# ansible-playbook ${var.kubespray_git} -t absent
#cp ${var.kubespray_path}ansible.cfg ./


  provisioner "local-exec" {
    command = <<EOT
    sleep 60;
  ansible-playbook ${var.kubespray_git} -t present
  ansible-playbook -i ${var.ansible_inventory} ${var.kubespray_path}cluster.yml --become
  ansible-playbook -i ${var.ansible_inventory} ${var.nmcli_path}
  ansible-playbook -i ${var.ansible_inventory} ${var.netplan_path}
  ansible-playbook -i ${var.ansible_inventory} ${var.kubeconfig_path} -l ${var.server_name_master}-001
  ansible-playbook -i ${var.ansible_inventory} ${var.kubedeploy_path}
  ansible-playbook ${var.kubespray_git} -t absent
  EOT
  }
}