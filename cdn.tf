data "azurerm_cdn_profile" "cdn" {
  name                = "cdn-${var.project}-${var.environment}"
  resource_group_name = data.azurerm_resource_group.platform.name
}

resource "azurerm_cdn_endpoint" "cdn" {
  name                = "cdn-${var.project}-${var.name}-${var.environment}"
  profile_name        = data.azurerm_cdn_profile.cdn.name
  location            = data.azurerm_cdn_profile.cdn.location
  resource_group_name = data.azurerm_cdn_profile.cdn.resource_group_name

  origin_host_header = data.azurerm_storage_account.shared.primary_blob_host
  origin {
    name      = "web${var.name}${var.environment}"
    host_name = data.azurerm_storage_account.shared.primary_blob_host
  }

  delivery_rule {
    name  = "httptohttps"
    order = 1

    request_scheme_condition {
      match_values = ["HTTP"]
    }

    url_redirect_action {
      redirect_type = "Found"
      protocol      = "Https"
    }
  }

  delivery_rule {
    name  = "SpaRedirect"
    order = 2
    url_file_extension_condition {
      operator     = "LessThan"
      match_values = ["1"]
    }

    url_rewrite_action {
      source_pattern          = "/"
      destination             = "/${var.name}/index.html"
      preserve_unmatched_path = false
    }
  }

  delivery_rule {
    name  = "AssetRedirect"
    order = 3
    url_file_extension_condition {
      operator     = "GreaterThanOrEqual"
      match_values = ["1"]
    }

    url_rewrite_action {
      source_pattern = "/"
      destination    = "/${var.name}/"
    }
  }

  tags = merge(local.projectTags)

}

resource "azurerm_cdn_endpoint_custom_domain" "app" {
  name            = "${var.project}-${var.name}-${var.environment}"
  cdn_endpoint_id = azurerm_cdn_endpoint.cdn.id
  host_name       = "${azurerm_dns_cname_record.app.name}.${data.azurerm_dns_zone.dns.name}"

  cdn_managed_https {
    certificate_type = "Dedicated"
    protocol_type    = "ServerNameIndication"
  }
}
