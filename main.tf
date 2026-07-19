module "resource" {
  source = "./resource"
}

module "networking" {
  source              = "./networking"
  location            = module.resource.location
  resource_group_name = module.resource.name
}

module "storage" {
  source              = "./storage"
  location            = module.resource.location
  resource_group_name = module.resource.name
}
