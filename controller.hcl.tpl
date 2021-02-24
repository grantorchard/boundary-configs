controller {
  name = "example-controller"
  description = "An example controller"
	database {
      url = "env://BOUNDARY_POSTGRES_URL"
  }
}

listener "tcp" {
  # Should be the address of the NIC that the controller server will be reached on
  address = "${attr.unique.network.ip-address}"
  # The purpose of this listener block
  purpose = "api"

  tls_disable = true

  # Uncomment to enable CORS for the Admin UI. Be sure to set the allowed origin(s)
  # to appropriate values.
  #cors_enabled = true
  #cors_allowed_origins = ["yourcorp.yourdomain.com"]
}

# Data-plane listener configuration block (used for worker coordination)
listener "tcp" {
  # Should be the IP of the NIC that the worker will connect on
  address = "${attr.unique.network.ip-address}"
  # The purpose of this listener
  purpose = "cluster"

  tls_disable = true
}

kms "transit" {
  purpose            = "root"
  address            = "https://vault-cluster.vault.11eb56d6-0f95-3a99-a33c-0242ac110007.aws.hashicorp.cloud:8200"
  disable_renewal    = "false"

  // Key configuration
  key_name           = "boundary_root"
  mount_path         = "transit/"
  namespace          = "admin/"
}

kms "transit" {
  purpose            = "worker-auth"
  address            = "https://vault-cluster.vault.11eb56d6-0f95-3a99-a33c-0242ac110007.aws.hashicorp.cloud:8200"
  disable_renewal    = "false"

  // Key configuration
  key_name           = "boundary_worker_auth"
  mount_path         = "transit/"
  namespace          = "admin/"
}

kms "transit" {
  purpose            = "recovery"
  address            = "https://vault-cluster.vault.11eb56d6-0f95-3a99-a33c-0242ac110007.aws.hashicorp.cloud:8200"
  disable_renewal    = "false"

  // Key configuration
  key_name           = "boundary_recovery"
  mount_path         = "transit/"
  namespace          = "admin/"
}