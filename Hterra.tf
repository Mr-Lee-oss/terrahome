provider "azurerm" {

version = "~>2.0"
    features {}
}

resource "azurerm_resource_group" "RG" {
    name = "Tera-RG"
    location = "Korea Central"
}

module "network-security-group" {
    source = "Azure/Network-security-group/azurerm"
    resource_group_name = azurerm_resource_group.RG.name
    location = "korea Central"
    security_group_name = "Terra-NSG"
    source_address_prefix = ["10.1.4.0/24"]
     predefined_rules = [
        {
            name = "SSH"
            priority = "500"
        },
        {
            name = "LDAP"
            source_port_range = "1024-1026"
        }
    ]
    custom_rules = [
        {
            name = "Terra-http"
            priority = "100"
            direction = "Inbound"
            protocol = "tcp"
            destination_port_range = "80"
            description = "description-http"
        }
    ]
}

resource "azurerm_virtual_network" "Terra-Net" {
    name = "Terra-Net"
    resource_group_name = azurerm_resource_group.RG.name
    location = "Korea Central"
    address_space = ["10.1.0.0/16"]
    dns_servers = ["10.0.04", "10.0.0.5"]   

    subnet{
        name = "Terra-subnet1"
        address_prefix= "10.1.1.0/24"
    }
    subnet{
        name = "Terra-subnet2"
        address_prefix= "10.1.2.0/24"
    }
    subnet{
        name = "Terra-etc"
        address_prefix= "10.1.3.0/24"
    }
}

