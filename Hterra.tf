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
    source_address_prefix = ["10.5.4.0/24"]
     predefined_rules = [
        {
            name = "SSH"
            priority = "500"
            destinationAddressPrefix = "*"
             source_port_range = "*"
        },
        {
            name = "LDAP"
            destinationAddressPrefix = "*"
            source_port_range = "*"
        }
    ]
    custom_rules = [
        {
            name = "Terra-http"
            priority = "100"
            direction = "Inbound"
            access = "Allow"
            protocol = "tcp"
            source_port_range ="*"
            destination_port_range = "80" 
            description = "80번 허용!"
          
        }
    ]
}

resource "azurerm_virtual_network" "Terra-Net" {
    name = "Terra-Net"
    resource_group_name = azurerm_resource_group.RG.name
    location = "Korea Central"
    address_space = ["10.5.0.0/16"]
    dns_servers = ["10.5.04", "10.5.0.5"]   

    subnet{
        name = "Terra-subnet1"
        address_prefix= "10.5.1.0/24"
    }
    subnet{
        name = "Terra-subnet2"
        address_prefix= "10.5.2.0/24"
    }
    subnet{
        name = "Terra-etc"
        address_prefix= "10.5.3.0/24"
    }
}

