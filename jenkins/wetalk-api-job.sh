cat << EOF > /tmp/wetalk-api.hcl 
job "wetalk-api" {
  datacenters = ["local-cluster"]
  type = "service"

  group "wetalk-api" {
    count = 1
    network {
      port "http" {
        to = 8080
      }
    }

    service {
      name = "wetalk-api"
      tags = ["urlprefix-/api"]
      port = "http"
      check {
        name     = "alive"
        type     = "http"
        path     = "/api/actuator/health"
        interval = "10s"
        timeout  = "2s"
      }
    }

    restart {
      attempts = 2
      interval = "30m"
      delay = "15s"
      mode = "fail"
    }

    task "wetalk-api" {
      driver = "docker"
      config {
        image = "frjperezcostas/wetalk-api:latest"
        ports = ["http"]
      }
    }
  }
}
EOF
nomad run /tmp/wetalk-api.hcl
rm /tmp/wetalk-api.hcl