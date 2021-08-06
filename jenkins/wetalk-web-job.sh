cat << EOF > /tmp/wetalk-web.hcl
job "wetalk-web" {
  datacenters = ["local-cluster"]
  type = "service"

  group "wetalk-web" {
    count = 1
    network {
      port "http" {
        to = 80
      }
    }

    service {
      name = "wetalk-web"
      tags = ["urlprefix-/"]
      port = "http"
      check {
        name     = "alive"
        type     = "http"
        path     = "/"
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

    task "wetalk-web" {
      driver = "docker"
      config {
        image = "frjperezcostas/wetalk-web:latest"
        ports = ["http"]
      }
    }
  }
}
EOF
nomad run /tmp/wetalk-web.hcl
rm /tmp/wetalk-web.hcl
