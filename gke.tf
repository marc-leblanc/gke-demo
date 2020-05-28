# Vars:
##    cluster_name | 
##    project_name | 
##    location  | 
resource "google_container_cluster" "kubernetes_cluster" {
  name     = var.cluster_name
  project  = var.project_name
  location = var.location

  initial_node_count = var.initial_node_count
  network            = var.network

  node_config {
    machine_type = var.machine_type

    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
  #depends_on=[google_compute_network.vpc_network]
}
# This next section only needed if the network -does not- already exist
#resource "google_compute_network" "vpc_network" {
#  name = "default"
#}

variable "project_name" {
  description = "project to deploy kubernetes cluster into"
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

variable "machine_type" {
  description = "size of the compute resources"
  default     = "n1-standard-1"
}

