controller {
  name = "boundary-controller"
  description = "Boundary Controller on {{ env "attr.unique.hostname" }}"
	database {
      url = "env://BOUNDARY_POSTGRES_URL"
  }
	public_cluster_addr = "boundary_worker_access.service.consul"
}

listener "tcp" {
  address     = "0.0.0.0:9200"
  purpose     = "api"
  tls_disable = true
}

listener "tcp" {
  address = "0.0.0.0:9201"
  purpose = "cluster"
  tls_disable = true
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