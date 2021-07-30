# k8s-infra

k8s with Hetzner as Cloudprovider and terraform cloud-init and ansible
OS, ssh and Firewall hardining will be a part of it
it should be a full production ready secure setup for my infrastructure

wip

Instruction

you need a Hetzner Account
Hetzner API-Key for hcloud

kubectl
```
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl
```

needed Pip Packages
```
ansible==3.4.0
ansible-base==2.10.11
cryptography==2.8
jinja2==2.11.3
netaddr==0.7.19
pbr==5.4.4
jmespath==0.9.5
ruamel.yaml==0.16.10
ruamel.yaml.clib==0.2.2
MarkupSafe==1.1.1
kubernetes
```
Terraform
```
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt install terraform
```
clone the repo and go to ./terraform and create terraform.tfvars file
```
// hcloud Token
hcloud_token = "1234566example"

// Public Key Path
public_key_path = "~/.ssh/your.pub"

// Private Key Path
private_key_path = ""~/.ssh/your""

// Ansible Inventory User
ansible_user = "example-admin"

// Public Key
public_key = "ssh-ed25519 AAAADKGRFC1l........"
```
cd ./terraform

terraform init
teraform apply
