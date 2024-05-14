@description('Base name of the resource such as web app name and app service plan ')
@minLength(2)
param webAppName string = 'metadent-app-poc-01'

@description('The SKU of App Service Plan ')
param sku string = 'S1'

@description('The Runtime stack of current web app')
param linuxFxVersion string = 'php|8.2'

@description('Location for all resources.')
param location string = resourceGroup().location

var webAppPortalName = '${webAppName}'
var appServicePlanName = 'web-lin-poc-01'

resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
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

resource webAppPortal 'Microsoft.Web/sites@2022-03-01' = {
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
