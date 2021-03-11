data "google_compute_regions" "available" {
}

data "google_client_config" "provider" {
}

data "google_netblock_ip_ranges" "lb_hc" {
  range_type = "health-checkers"
}

data "google_dns_managed_zone" "uid2-0" {
  name = var.domain_managed_zone
}

locals {
  # Creative way to obtain project id without enabling Cloud Resource Manager API
  project_id = split(".", split("@", google_service_account.compute.email)[1])[0]
}