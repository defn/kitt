data_dir = "/consul/data/"
log_level = "DEBUG"

datacenter = "dc1"
primary_datacenter = "dc1"

server = true

bootstrap_expect = 1
ui = true

bind_addr = "{{GetInterfaceIP \"eth0\"}}"
client_addr = "{{GetInterfaceIP \"eth0\"}}"
advertise_addr = "169.254.32.1"

ports {
  grpc = 8502
}

connect {
  enabled = true
  #enable_mesh_gateway_wan_federation = true
}

enable_central_service_config = true

acl = {
  enabled = true
  default_policy = "deny"
  enable_token_persistence = true

  tokens {
    master = "FBAF54CC-E03D-4763-9F19-376114D3857B"
    agent = "FBAF54CC-E03D-4763-9F19-376114D3857B"
  }
}
