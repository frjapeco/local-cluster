NETWORK_NAME = "local-cluster"
SERVER_NODES_COUNT = 2
CLIENT_NODES_COUNT = 3

Vagrant.configure("2") do |config|

    config.vm.define "server-01" do |node|
        node.vm.box = "bento/ubuntu-20.04"
        node.vm.hostname = "server-01"
        node.vm.network "private_network", ip: "10.0.0.4", virtualbox__intnet: NETWORK_NAME
        node.vm.network "forwarded_port", host: 9000, guest: 8500     # Consul
        node.vm.network "forwarded_port", host: 9001, guest: 4646     # Nomad
        node.vm.network "forwarded_port", host: 9002, guest: 8080     # Jenkins
    end

    config.vm.define "server-02" do |node|
        node.vm.box = "bento/ubuntu-20.04"
        node.vm.hostname = "server-02"
        node.vm.network "private_network", ip: "10.0.0.5", virtualbox__intnet: NETWORK_NAME
    end

    config.vm.define "client-01" do |node|
        node.vm.box = "bento/ubuntu-20.04"
        node.vm.hostname = "client-01"
        node.vm.network "private_network", ip: "10.0.0.6", virtualbox__intnet: NETWORK_NAME
        node.vm.network "forwarded_port", host: 9003, guest: 9998    # Fabio
        node.vm.network "forwarded_port", host: 9999, guest: 9999
    end

    config.vm.define "client-02" do |node|
        node.vm.box = "bento/ubuntu-20.04"
        node.vm.hostname = "client-02"
        node.vm.network "private_network", ip: "10.0.0.7", virtualbox__intnet: NETWORK_NAME
    end

    config.vm.define "client-03" do |node|
        node.vm.box = "bento/ubuntu-20.04"
        node.vm.hostname = "client-03"
        node.vm.network "private_network", ip: "10.0.0.8", virtualbox__intnet: NETWORK_NAME
        node.vm.provision "ansible" do |ansible|
            ansible.playbook = "start-cluster.yml"
            ansible.limit = "all"
            ansible.groups = {
              "server_nodes" => ["server-01","server-02"],
              "client_nodes" => ["client-01","client-02","client-03"]
            }
        end
    end
  
end