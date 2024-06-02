@description('Base name of the resource such as web app name and app service plan ')
@minLength(2)
param webAppNameFrontend string
param webAppNameBackend string
param dnsZoneFrontend string
param dnsZoneBackend string
param appServicePlanResourceGroupName string
param appServicePlanName string
param vnetResourceGroupName string
param vnetName string

@description('The Runtime stack of current web app')
param linuxFxVersionFe string = 'NODE|20-lts'
param linuxFxVersionBe string = 'php|8.2'

@description('Location for all resources.')
var location = resourceGroup().location
var subnetName = 'WEB'

module appServicePlanModule '../../_shared_dev/app_service_plans/asp.bicep' = {
  scope: resourceGroup(appServicePlanResourceGroupName)
  name: 'appServicePlanModule'
  params: {
    sku: 'b2'
    appServicePlanName: appServicePlanName
  }
}

resource vnetResource 'Microsoft.Network/virtualNetworks@2022-09-01' existing = {
  scope: resourceGroup(vnetResourceGroupName)
  name: vnetName
}

var subnetResourceId = '${vnetResource.id}/subnets/${subnetName}'

resource webAppFe 'Microsoft.Web/sites@2022-03-01' = {
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

resource webAppBe 'Microsoft.Web/sites@2022-03-01' = {
  name: webAppNameBackend
  location: location
  kind: 'app'
  properties: {
    serverFarmId: appServicePlanModule.outputs.appServicePlanId
    virtualNetworkSubnetId: subnetResourceId 
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

// module AppCustomHostEnableFrontend './hostname.bicep' = {
//   name: '${webAppFe.name}-sni-enable'
//   params: {
//     appName: webAppFe.name
//     dnsZone: dnsZoneFrontend
//     hostPlanId: appServicePlanModule.outputs.appServicePlanId
//     location: location
//   }
// }

// module AppCustomHostEnableBackend './hostname.bicep' = {
//   name: '${webAppBe.name}-sni-enable'
//   params: {
//     appName: webAppBe.name
//     dnsZone: dnsZoneBackend
//     hostPlanId: appServicePlanModule.outputs.appServicePlanId
//     location: location    
//   }
// }
