# Vars:
##    cluster_name | 
##    project_name | 
##    location  | 

# Vault Required IAM
data "google_compute_default_service_account" "default" {
  project = local.project_id
}

# Set K8S Node Service Account - either default or user provided
variable "service_account" {
  default     = ""
  description = "The GCP Service Account to be used by the node VMs"
}

resource "google_container_cluster" "kubernetes_cluster" {
  name     = var.cluster_name
  project  = var.project_id
  location = var.location

  initial_node_count = var.initial_node_count
  network            = var.network
  subnetwork         = var.subnetwork
  service_account    = var.service_account != "" ? var.service_account : data.google_compute_default_service_account.default.email
  node_config {
    preemptible  = var.preemptible
    machine_type = var.machine_type

    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
  # depends_on = [google_compute_network.vpc_network] #Uncomment if creating google_compute_network.vpc_network below
}

variable "project_id" {
  description = "GCP Project ID for GKE deployment"
}


variable "location" {
  description = "location to deploy kubernetes cluster into"
  default     = "us-central1-a"
}

variable "cluster_name" {
  description = "name of kubernetes cluster"
}

variable "initial_node_count" {
  description = "initial amount of nodes to deploy for the kubernetes cluster"
  default     = "1"
}

variable "network" {
  description = "network that the compute resources of the kubernetes cluster are in"
  default     = "default"
}

variable "subnetwork" {
  default = "default"
}

variable "machine_type" {
  description = "size of the compute resources"
  default     = "n1-standard-1"
}

variable "preemptible" {
  description = "Pre-emptible nodes True/False"
  default     = true
}

data "google_client_config" "default" {
}

output "gke_endpoint" {
  value = google_container_cluster.kubernetes_cluster.endpoint
}

output "gke_access_token" {
  value = data.google_client_config.default.access_token
}
output "gke_cluster_ca_cert" {
  value = google_container_cluster.kubernetes_cluster.master_auth.0.cluster_ca_certificate
}