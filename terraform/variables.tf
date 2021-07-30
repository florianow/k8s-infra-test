// Ansible Inventory
variable "ansible_inventory" {
  default = "../ansible/inventory/hcloud.yml"
}

// Ansible netplan path
variable "nmcli_path" {
  default = "../ansible/playbooks/ansible-nmcli.yml"
}

// Ansible netplan path
variable "netplan_path" {
  default = "../ansible/playbooks/ansible-netplan.yml"
}

// Ansible Baseline path
variable "baseline_path" {
  default = "../ansible/playbooks/ansible_role_baseline.yml"
}

// Ansible Kubespray Path
variable "known_hosts" {
  default = "../ansible/playbooks/ansible_known_hosts.yml"
}

// Ansible Kubespray Path
variable "kubespray_git" {
  default = "../ansible/playbooks/ansible_git_kubespray.yml"
}

// Ansible Kubespray Path
variable "kubespray_path" {
  default = "../ansible/kubespray/"
}

// Ansible Kubespray Path
variable "kubeconfig_path" {
  default = "../ansible/playbooks/ansible_kube_config.yml"
}

// Ansible Kubespray Path
variable "kubedeploy_path" {
  default = "../ansible/playbooks/ansible_kube_deployments.yml"
}

// Public Key
variable "public_key" {}

// Public Key
variable "public_key_path" {}

// Private Key
variable "private_key_path" {}

// Ansible User
variable "ansible_user" {}

// Host Name / Host Name Mster
variable "server_name_master" {
  type    = string
  default = "kub-ma"
}

// Host Name / Host Name Mster
variable "server_name_node" {
  type    = string
  default = "kub-no"
}

// VM node
variable "server_type_node" {
  type    = string
  default = "cpx11"
}

// VM master
variable "server_type_master" {
  type    = string
  default = "cx11"
}
#TODO CentOS/fedora/debian works not so far
// VM Image (ubuntu-20.04)
variable "image" {
  type    = string
  default = "ubuntu-20.04"
}

// Number of Master you want to provision
variable "master_count" {
  type    = string
  default = "1"
}

// Number of nodes you want to provision
variable "node_count" {
  type    = string
  default = "2"
}

// API Token Hetzner Cloud
variable "hcloud_token" {}
