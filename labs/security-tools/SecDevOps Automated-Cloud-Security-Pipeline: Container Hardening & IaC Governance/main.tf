# ==============================================================================
# Azure Network Security Group with Terraform
# ==============================================================================
# This Terraform configuration creates a restrictive Network Security Group
# that only allows HTTPS (port 443) inbound traffic and denies all other
# inbound connections.
#
# Prerequisites:
# 1. Azure CLI installed and configured
# 2. Terraform installed (>= 1.0.0)
# 3. Active Azure subscription
#
# Setup Steps:
# 1. Login to Azure:
#    az login --use-device-code
#
# 2. Register required Azure Resource Providers:
#    az provider register --namespace Microsoft.Network
#    az provider register --namespace Microsoft.Compute
#    az provider register --namespace Microsoft.Storage
#
# 3. Verify provider registration (wait until "Registered"):
#    az provider show --namespace Microsoft.Network --query "registrationState"
#    az provider show --namespace Microsoft.Compute --query "registrationState"
#
# 4. Initialize Terraform:
#    terraform init
#
# 5. Preview changes:
#    terraform plan
#
# 6. Apply configuration:
#    terraform apply
#
# 7. Clean up resources when done:
#    terraform destroy
# ==============================================================================

terraform {
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = "~>3.0"
    }
  }
  required_version = ">= 1.0.0"
}

provider "azurerm" {
  features {
  }
}

resource "azurerm_resource_group" "main" {
  name     = "rg-secdevops-lab"
  location = "West US 2"
}

resource "azurerm_virtual_network" "main" {
  name                = "vnet-secdevops-lab"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "main" {
  name                 = "snet-secdevops-lab"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "restrictive_nsg" {
  name                = "nsg-allow-specific-port"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  tags = {
    Environment = "Lab"
    Purpose     = "SecDevOps"
  }
}

resource "azurerm_network_security_rule" "allow_https" {
  name                        = "Allow-HTTPS"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.restrictive_nsg.name
}

resource "azurerm_network_security_rule" "deny_all_inbound" {
  name                        = "Deny-All-Inbound"
  priority                    = 4096
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.restrictive_nsg.name
}

resource "azurerm_network_security_rule" "allow_all_outbound" {
  name                        = "Allow-All-Outbound"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.restrictive_nsg.name
}

resource "azurerm_subnet_network_security_group_association" "main" {
  subnet_id                 = azurerm_subnet.main.id
  network_security_group_id = azurerm_network_security_group.restrictive_nsg.id
}