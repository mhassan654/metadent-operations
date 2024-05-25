@description('Base name of the resource such as web app name and app service plan ')
@minLength(2)
param webAppName string = 'metadent-dev-fe-01'
param webAppName2 string = 'metadent-dev-be-01'

@description('The Runtime stack of current web app')
param linuxFxVersionFe string = 'NODE|20-lts'
param linuxFxVersionBe string = 'php|8.2'

@description('Location for all resources.')
param location string = resourceGroup().location

var webAppPortalName = '${webAppName}'
var webAppPortalName2 = '${webAppName2}'

module appServicePlanModule '../_shared_dev/app_service_plans/asp.bicep' = {
  name: 'appServicePlanModule'
}

resource webAppPortalFe 'Microsoft.Web/sites@2022-03-01' = {
  name: webAppPortalName
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
  name: webAppPortalName2
  location: location
  kind: 'app'
  properties: {
    serverFarmId: appServicePlanModule.outputs.appServicePlanId
    siteConfig: {
      linuxFxVersion: linuxFxVersionBe
      ftpsState: 'FtpsOnly'
    }
    httpsOnly: true
  }
  identity: {
    type: 'SystemAssigned'
  }
}
