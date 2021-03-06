disable_mlock = true

listener "tcp" {
    purpose = "proxy"
    address = "0.0.0.0:9202"
		tls_cert_file = "${NOMAD_SECRETS_DIR}/certificate.crt"
		tls_key_file = "${NOMAD_SECRETS_DIR}/private_key.key"
}

worker {
  name = "worker-{{ env "NOMAD_ALLOC_INDEX" }}"
  description = "A default worker created demonstration"
  controllers = [
    "boundary-cluster.service.consul"
  ]

  public_addr = "env://BOUNDARY_PUBLIC_WORKER_ADDR"

  tags {
    type   = ["dev"]
    region = ["humblelab"]
  }
}

kms "transit" {
  purpose            = "root"
  disable_renewal    = "false"

  key_name           = "boundary_root"
  mount_path         = "transit/"
  namespace          = "admin/"
}

kms "transit" {
  purpose            = "worker-auth"
  disable_renewal    = "false"

  key_name           = "boundary_worker_auth"
  mount_path         = "transit/"
  namespace          = "admin/"
}

kms "transit" {
  purpose            = "recovery"
  disable_renewal    = "false"

  key_name           = "boundary_recovery"
  mount_path         = "transit/"
  namespace          = "admin/"
}