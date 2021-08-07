NETWORK_NAME = "local-cluster"
LINUX_DISTRO = "bento/ubuntu-20.04"
SERVER_NODES_COUNT = 2
CLIENT_NODES_COUNT = 3

Vagrant.configure("2") do |config|

    serverNodes = []
    clientNodes = []

    (1..SERVER_NODES_COUNT).each do |i|
        serverId = "server-#{i}"
        serverNodes << serverId
        config.vm.define serverId do |server|
            server.vm.box = LINUX_DISTRO
            server.vm.hostname = serverId
            server.vm.network "private_network", ip: "10.0.0.#{i+3}", virtualbox__intnet: NETWORK_NAME
            if i == 1
                server.vm.network "forwarded_port", host: 9000, guest: 8500     # Consul
                server.vm.network "forwarded_port", host: 9001, guest: 4646     # Nomad
                server.vm.network "forwarded_port", host: 9002, guest: 8080     # Jenkins
            end
        end
    end

    (1..CLIENT_NODES_COUNT).each do |i|
        clientId = "client-#{i}"
        clientNodes << clientId
        config.vm.define clientId do |client|
            client.vm.box = LINUX_DISTRO
            client.vm.hostname = clientId
            client.vm.network "private_network", ip: "10.0.0.#{i+SERVER_NODES_COUNT+3}", virtualbox__intnet: NETWORK_NAME
            if i == 1
                client.vm.network "forwarded_port", host: 9003, guest: 9998     # Fabio
                client.vm.network "forwarded_port", host: 9999, guest: 9999     # Deployed app
            end
            if i == CLIENT_NODES_COUNT
                client.vm.provision "ansible" do |ansible|
                    ansible.playbook = "start-cluster.yml"
                    ansible.limit = "all"
                    ansible.groups = {
                      "server_nodes" => serverNodes,
                      "client_nodes" => clientNodes
                    }
                end
            end
        end
    end
  
end