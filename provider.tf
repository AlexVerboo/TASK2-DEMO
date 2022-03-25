terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.12.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.1"
    }
  }
}
data "google_client_config" "default" {}
provider "google" {
  # Configuration options
  project="sapient-stacker-344918"
  region  = "us-central1"
}

data "google_container_cluster" "my_cluster" {
  name     = "my-gke-cluster"
  location = "us-central1"
}

provider "kubernetes" {
  
  host = "https://34.133.200.62"
  token   = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(data.google_container_cluster.my_cluster.master_auth[0].cluster_ca_certificate)
}