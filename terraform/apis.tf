resource "google_project_service" "apis" {
  for_each = toset([
    "servicemanagement.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "domains.googleapis.com",
  ])

  service = each.key

  project            = local.project_id
  disable_on_destroy = false
}
