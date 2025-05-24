terraform {
  required_providers {
    solacebroker = {
      source = "registry.terraform.io/solaceproducts/solacebroker"
    }
  }
}

# Configure the provider
provider "solacebroker" {
  username = "admin"
  password = "admin"
  url      = "http://localhost:8080"
}