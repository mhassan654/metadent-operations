@description('Base name of the resource such as web app name and app service plan ')
@minLength(2)
param webAppNameFrontend string = 'metadent-afr-dev-fe-01'
param webAppNameBackend string = 'metadent-afr-dev-be-01'

@description('The Runtime stack of current web app')
param linuxFxVersionFe string = 'NODE|20-lts'
param linuxFxVersionBe string = 'php|8.2'

@description('Location for all resources.')
param location string = resourceGroup().location

var appServicePlanResourceGroupName = 'web-afr-dev-rg'
var vnetResourceGroupName = 'network-afr-dev-rg'

module appServicePlanModule '../../_shared_dev/app_service_plans/asp.bicep' = {
  scope: resourceGroup(appServicePlanResourceGroupName)
  name: 'appServicePlanModule'
}

module vnetModule '../../_shared_dev/virtual_networks/vnets.bicep' = {
  scope: resourceGroup(vnetResourceGroupName)
  name: 'vnetModule'
}

resource webAppPortalFe 'Microsoft.Web/sites@2022-03-01' = {
  name: webAppNameFrontend
  location: location
  kind: 'app'
  properties: {
    serverFarmId: appServicePlanModule.outputs.appServicePlanId
    siteConfig: {
      linuxFxVersion: linuxFxVersionFe
      ftpsState: 'FtpsOnly'
    }
    httpsOnly: true
  }
  identity: {
    type: 'SystemAssigned'
  }
}

resource webAppPortalBe 'Microsoft.Web/sites@2022-03-01' = {
  name: webAppNameBackend
  location: location
  kind: 'app'
  properties: {
    serverFarmId: appServicePlanModule.outputs.appServicePlanId
    virtualNetworkSubnetId: vnetModule.outputs.subnetWebResourceId    
    siteConfig: {
      linuxFxVersion: linuxFxVersionBe
      ftpsState: 'FtpsOnly'
    }
    httpsOnly: true
    vnetRouteAllEnabled: true    
  }
  identity: {
    type: 'SystemAssigned'
  }
}
