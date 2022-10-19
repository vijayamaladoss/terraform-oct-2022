terraform {
  required_providers {
    docker = {
        source = "kreuzwerker/docker"
        version = "~> 2.13.0"
    }
  }
}

provider "docker" {
    host = "tcp://20.198.95.84:4243"
}

resource "docker_image" "nginx" {
  name = "nginx:latest"
  keep_locally = false
}

resource "docker_container" "nginx" {
    image = docker_image.nginx.latest
    name = "my-nginx"
    ports {
        internal = 80
        external   = 8080
    }
}
