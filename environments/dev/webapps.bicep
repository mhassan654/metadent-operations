@description('metadent backend dev one and Basic app service plan')
@minLength(2)
param webAppName string = 'metadent-fe-dev-01'

@description('The SKU of App Service Plan')
param sku string = 'B1'

@description('The runtime stack of current web app')
param linuxFxVersion string = 'Node|20'

@description('Location for all resources.')
param location string = resourceGroup().location

var webAppPortalName = webAppName
var appServicePlanName = 'web-lin-dev-01'

resource appServicePlan 'Microsoft.Web/serverfarms@2023-12-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: sku
  }
  kind: 'linux'
  properties: {
    reserved: true
  }
}

resource webAppPortal 'Microsoft.Web/sites@2023-12-01' = {
  name: webAppPortalName
  location: location
  kind: 'app'
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      linuxFxVersion: linuxFxVersion
      ftpsState: 'FtpsOnly'
    }
    httpsOnly: true
  }
  identity: { 
    type: 'SystemAssigned'
   }
}
