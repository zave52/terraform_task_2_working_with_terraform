resource "azurerm_resource_group" "resource_group" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_storage_account" "storage_account" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.resource_group.name
  location                 = azurerm_resource_group.resource_group.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "storage_container" {
  name                  = var.container_name
  storage_account_id    = azurerm_storage_account.storage_account.id
  container_access_type = "private"
}

resource "azurerm_storage_blob" "storage_blob" {
  name                   = var.blob_name
  storage_account_name   = azurerm_storage_account.storage_account.name
  storage_container_name = azurerm_storage_container.storage_container.name
  type                   = "Block"
  source                 = data.archive_file.terraform_code.output_path
}

data "archive_file" "terraform_code" {
  type        = "tar.gz"
  output_path = "${path.module}/terraform.tar.gz"

  source {
    content  = file("${path.module}/main.tf")
    filename = "main.tf"
  }

  source {
    content  = file("${path.module}/provider.tf")
    filename = "provider.tf"
  }

  source {
    content  = file("${path.module}/variables.tf")
    filename = "variables.tf"
  }

  source {
    content  = file("${path.module}/outputs.tf")
    filename = "outputs.tf"
  }
}
