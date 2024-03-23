# Vagrant

- Website: [https://www.vagrantup.com/](https://www.vagrantup.com/)
- Source: [https://github.com/hashicorp/vagrant](https://github.com/hashicorp/vagrant)
- HashiCorp Discuss: [https://discuss.hashicorp.com/c/vagrant/24](https://discuss.hashicorp.com/c/vagrant/24)

By default, when running Vagrant inside WSL2 instance it uses the hypervisor(VirtualBox, VMware or such) that is set up on the host machine.
The following repository contains an envar VAGRANT_WSL_NESTED_VIRTUALIZATION which when set to true, allows you to run Vagrant on WSL2 with nested virtualization enabled and VirtualBox installed inside the WSL instance.

# Installing from Source
Clone the repository locally.
## Install Ruby
    sudo apt install ruby-dev
## Clean bundle cache.
    bundle clean
## Install with the following commands
    bundle install
    bundle --binstubs exec
## Add the following to the .bashrc file
    export PATH="$(dirname ~/vagrant/exec)/exec:$PATH"
    export VAGRANT_WSL_NESTED_VIRTUALIZATION=true

Running vagrant in WSL2 will use the hypervisor installed on the WSL2 instance enabling true nested virtualization.

