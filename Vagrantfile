NETWORK_NAME = "local-cluster"
LINUX_DISTRO = "bento/ubuntu-20.04"
SERVER_NODES_COUNT = 1
CLIENT_NODES_COUNT = 1

ClusterNode = Struct.new(:id, :ip)

Vagrant.configure("2") do |config|

    clusterNodes = []

    (1..SERVER_NODES_COUNT).each do |i|
        clusterNodes << ClusterNode.new("server-#{i}","10.0.0.#{i+3}")
        serverId = clusterNodes[i-1].id
        serverIp = clusterNodes[i-1].ip
        config.vm.define serverId do |server|
            server.vm.box = LINUX_DISTRO
            server.vm.hostname = serverId
            server.vm.network "private_network", ip: serverIp, virtualbox__intnet: NETWORK_NAME
            if i == 1
                server.vm.network "forwarded_port", guest: 8500, host: 9000     # consul
                server.vm.network "forwarded_port", guest: 4646, host: 9001     # nomad
                server.vm.network "forwarded_port", guest: 8080, host: 9002     # jenkins
            end
        end
    end

    (1..CLIENT_NODES_COUNT).each do |i|
        clusterNodes << ClusterNode.new("client-#{i}","10.0.0.#{i+SERVER_NODES_COUNT+3}")
        clientId = clusterNodes[i-1].id
        clientIp = clusterNodes[i-1].ip
        config.vm.define clientId do |client|
            client.vm.box = LINUX_DISTRO
            client.vm.hostname = clientId
            client.vm.network "private_network", ip: clientIp, virtualbox__intnet: NETWORK_NAME
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