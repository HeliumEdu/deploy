unless Vagrant.has_plugin?("vagrant-hostsupdater")
  system('vagrant plugin install vagrant-hostsupdater')
end

unless Vagrant.has_plugin?("vagrant-host-shell")
  system('vagrant plugin install vagrant-host-shell')
end

system("
  if [ #{ARGV[0]} = 'up' ]; then
    bin/platform-cli pull
  fi
")

Vagrant.configure("2") do |config|
  config.ssh.forward_agent = true
  config.ssh.insert_key = true

  config.vm.define "devbox" do |node|
    node.vm.box = "ubuntu/xenial64"

    node.vm.network "private_network", ip: "10.1.0.10"

    node.vm.hostname = "heliumedu.dev"

    node.hostsupdater.aliases = [
      "graphite.heliumedu.dev",
      "grafana.heliumedu.dev"
    ]

    node.vm.synced_folder "./projects", "/srv/helium"

    node.vm.provider "virtualbox" do |vb|
      vb.name = "helium"
      vb.gui = false
      vb.memory = "4096"
      vb.cpus = 2
      vb.customize [ "guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 1000 ]
    end

    node.vm.provision :host_shell, run: "always" do |host_shell|
      host_shell.inline = "./bin/_vagrant_prepare.sh"
    end

    # Provision environment variables only
    if ARGV.include? '--provision-with'
      node.vm.provision "envvars", type: "ansible" do |ansible|
        ansible.playbook = "ansible/devbox.yml"
        ansible.verbose = true
        ansible.groups = { "devbox" => ["devbox"] }
        ansible.extra_vars = {
          ip_address: "10.1.0.10"
        }
        ansible.tags = ["envvars"]
      end
    end

    # Provision
    node.vm.provision "shell" do |shell|
      shell.inline = "apt-get install -y python"
    end

    node.vm.provision "main", type: "ansible" do |ansible|
      ansible.playbook = "ansible/devbox.yml"
      ansible.verbose = true
      ansible.groups = { "devbox" => ["devbox"] }
      ansible.extra_vars = {
        ip_address: "10.1.0.10"
      }
    end
  end
end
