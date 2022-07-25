data "azurerm_dns_zone" "dns" {
  name                = var.domain
  resource_group_name = data.azurerm_resource_group.platform.name
}

resource "azurerm_dns_cname_record" "app" {
  name                = var.subdomain
  zone_name           = data.azurerm_dns_zone.dns.name
  resource_group_name = data.azurerm_dns_zone.dns.resource_group_name
  ttl                 = 3600
  target_resource_id  = azurerm_cdn_endpoint.cdn.id
}

