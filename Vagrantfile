NETWORK_NAME = "local-cluster"
LINUX_DISTRO = "bento/ubuntu-20.04"
SERVER_NODES_COUNT = 1
CLIENT_NODES_COUNT = 1

ClusterNode = Struct.new(:id, :ip)

Vagrant.configure("2") do |config|

    clusterNodes = []

    (1..SERVER_NODES_COUNT).each do |i|
        newServer = ClusterNode.new("server-#{i}","10.0.0.#{i+3}")
        clusterNodes << newServer
        config.vm.define newServer.id do |server|
            server.vm.box = LINUX_DISTRO
            server.vm.hostname = newServer.id
            server.vm.network "private_network", ip: newServer.ip, virtualbox__intnet: NETWORK_NAME
            if i == 1
                server.vm.network "forwarded_port", guest: 8500, host: 9000     # consul
                server.vm.network "forwarded_port", guest: 4646, host: 9001     # nomad
                server.vm.network "forwarded_port", guest: 8080, host: 9002     # jenkins
            end
        end
    end

    (1..CLIENT_NODES_COUNT).each do |i|
        newClient = ClusterNode.new("client-#{i}","10.0.0.#{i+SERVER_NODES_COUNT+3}")
        clusterNodes << newClient
        config.vm.define newClient.id do |client|
            client.vm.box = LINUX_DISTRO
            client.vm.hostname = newClient.id
            client.vm.network "private_network", ip: newClient.ip, virtualbox__intnet: NETWORK_NAME
            if i == 1
                client.vm.network "forwarded_port", guest: 9998, host: 9003     # fabio ui
                client.vm.network "forwarded_port", guest: 9999, host: 9999     # fabio lb
            end
            if i == CLIENT_NODES_COUNT
                serverNodes = clusterNodes.select{ |node| node.id.start_with?("server-")}
                serverIds = serverNodes.map { |node| node.id }
                serverIps = serverNodes.map { |node| node.ip }
                clientIds = clusterNodes.select{ |node| node.id.start_with?("client-")}.map { |node| node.id }
                client.vm.provision "ansible" do |ansible|
                    ansible.playbook = "start-cluster.yml"
                    ansible.limit = "all"
                    ansible.groups = {
                      "server_nodes" => serverIds,
                      "client_nodes" => clientIds
                    }
                    ansible.extra_vars = {
                        server_nodes_count: SERVER_NODES_COUNT,
                        server_ips: serverIps
                    }
                end
            end
        end
    end
  
end