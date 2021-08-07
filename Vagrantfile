# Basic config
NETWORK_NAME = "local-cluster"
LINUX_DISTRO = "bento/ubuntu-20.04"
SERVER_NODES_COUNT = 2
CLIENT_NODES_COUNT = 3

ClusterNode = Struct.new(:id, :ip)

Vagrant.configure("2") do |config|

    clusterNodes = []

    (1..SERVER_NODES_COUNT).each do |i|
        clusterNodes << ClusterNode.new("server-#{i}","10.0.0.#{i+3}")
        config.vm.define clusterNodes[i].id do |server|
            server.vm.box = LINUX_DISTRO
            server.vm.hostname = clusterNodes[i].id
            server.vm.network "private_network", ip: clusternodes[i].ip, virtualbox__intnet: NETWORK_NAME
            if i == 1
                server.vm.network "forwarded_port", guest: 8500, host: 9000     # Consul
                server.vm.network "forwarded_port", guest: 4646, host: 9001     # Nomad
                server.vm.network "forwarded_port", guest: 8080, host: 9002     # Jenkins
            end
        end
    end

    (1..CLIENT_NODES_COUNT).each do |i|
        clusterNodes << ClusterNode.new("clieent-#{i}","10.0.0.#{i+SERVER_NODES_COUNT+3}")
        config.vm.define clusterNodes[i].id do |client|
            client.vm.box = LINUX_DISTRO
            client.vm.hostname = clusterNodes[i].id
            client.vm.network "private_network", ip: clusterNodes[i].ip, virtualbox__intnet: NETWORK_NAME
            if i == 1
                client.vm.network "forwarded_port", guest: 9998, host: 9003     # Fabio
                client.vm.network "forwarded_port", guest: 9999, host: 9999     # Deployed app
            end
            if i == CLIENT_NODES_COUNT
                serverIds = clusterNodes.select{ |node| node.id.startswith("server-")}.map { |node| node.id }
                serverIps = clusterNodes.select{ |node| node.id.startswith("server-")}.map { |node| node.ip }
                clientIds = clusternodes.select{ |node| node.id.startswith("client-")}.map { |node| node.id }
                client.vm.provision "ansible" do |ansible|
                    ansible.playbook = "start-cluster.yml"
                    ansible.limit = "all"
                    ansible.groups = {
                      "server_nodes" => serverIds,
                      "client_nodes" => clientIds
                    }
                    ansible.extra.vars = {
                        server_nodes_count: SERVER_NODES_COUNT,
                        server_ips: serverIps
                    }
                end
            end
        end
    end
  
end