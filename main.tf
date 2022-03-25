#Service account y custom role
resource "google_service_account" "sa_servicio_task2" {
  account_id   = "sa-servicio-task2"
}
resource "google_project_iam_custom_role" "custom_role" {
  role_id     = "myCustomRoletask2"
  title       = "My Custom Role for 2"
  description = "A description"
  permissions = ["iam.roles.list","iam.roles.create", "iam.roles.delete","pubsub.schemas.get","pubsub.schemas.get","pubsub.schemas.list","pubsub.schemas.validate","pubsub.snapshots.get","pubsub.snapshots.list","pubsub.subscriptions.get","pubsub.subscriptions.list","pubsub.topics.get","pubsub.topics.list","resourcemanager.projects.get","serviceusage.quotas.get","serviceusage.services.get","serviceusage.services.list"]
}
#Recursos de red
resource "google_compute_subnetwork" "subnet_tarea" {
  name          = "demo-subnet"
  ip_cidr_range = "10.2.0.0/16"
  region        = "us-central1"
  network       = google_compute_network.net_tarea.id
  secondary_ip_range {
    range_name    = "tf-test-secondary-range-update1"
    ip_cidr_range = "192.168.10.0/24"
  }
}
resource "google_compute_network" "net_tarea" {
  name                    = "demo-network"
  auto_create_subnetworks = false
}


#Recurso Gooogle CLuster
resource "google_container_cluster" "primary" {
  name     = "my-gke-cluster"
  location = "us-central1"
  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1
  network = "projects/sapient-stacker-344918/global/networks/demo-network"
  subnetwork = "projects/sapient-stacker-344918/regions/us-central1/subnetworks/demo-subnet"
  //cluster_autoscaling {
  //    enabled = true
  //}

}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "my-node-pool"
  location   = "us-central1"
  cluster    = google_container_cluster.primary.name
  node_count = 1
  node_config {
    preemptible  = true
    machine_type = "n1-standard-1"

    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    service_account = "${google_service_account.sa_servicio_task2.email}"
    oauth_scopes    = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

#
resource "google_sql_database" "database" {
  name     = "gcp-training"
  instance = google_sql_database_instance.instance.name
  charset = "utf8"
}

# See versions at https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database_instance#database_version
resource "google_sql_database_instance" "instance" {
  name             = "my-database-instance"
  region           = "us-central1"
  database_version = "MYSQL_5_6"
  depends_on = [google_service_networking_connection.servicio_conexion]
  settings {
    tier = "db-n1-standard-1"
    activation_policy ="ALWAYS"
     ip_configuration {
      ipv4_enabled    = true
      private_network = "projects/sapient-stacker-344918/global/networks/demo-network"
    }
  }
  deletion_protection  = "true"
} 

resource "google_sql_user" "users" {
  name     = "admin"
  instance = google_sql_database_instance.instance.name
  password = "changeme"
}



#Dependencias de red

resource "google_compute_global_address" "private_ip_alloc" {
  name          = "private-ip-alloc"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = "projects/sapient-stacker-344918/global/networks/demo-network"
}

resource "google_service_networking_connection" "servicio_conexion" {
  network                 = "projects/sapient-stacker-344918/global/networks/demo-network"
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_alloc.name]
}