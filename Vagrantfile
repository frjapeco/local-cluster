Vagrant.configure("2") do |config|

    config.vm.define "server-01" do |node|
        node.vm.box = "bento/ubuntu-20.04"
        node.vm.hostname = "server-01"
        node.vm.network "private_network", ip: "10.0.0.4", virtualbox__intnet: "local-cluster"
        node.vm.network "forwarded_port", guest: 8500, host: 9000     # Consul
        node.vm.network "forwarded_port", guest: 4646, host: 9001     # Nomad
        node.vm.network "forwarded_port", guest: 8080, host: 9002     # Jenkins
    end

    config.vm.define "client-01" do |node|
        node.vm.box = "bento/ubuntu-20.04"
        node.vm.hostname = "client-01"
        node.vm.network "private_network", ip: "10.0.0.5", virtualbox__intnet: "local-cluster"
        node.vm.network "forwarded_port", guest: 9998, host: 9003    # Fabio
        node.vm.network "forwarded_port", guest: 9999, host: 9004
    end

    config.vm.define "client-02" do |node|
        node.vm.box = "bento/ubuntu-20.04"
        node.vm.hostname = "client-02"
        node.vm.network "private_network", ip: "10.0.0.6", virtualbox__intnet: "local-cluster"
    end

    config.vm.provision "ansible" do |ansible|
        ansible.playbook = "start-cluster.yml"
        ansible.groups = {
          "server_nodes" => ["server-01"],
          "client_nodes" => ["client-01","client-02"]
        }
    end
  
end