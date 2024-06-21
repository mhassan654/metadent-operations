@description('Base name of the resource such as web app name and app service plan ')
@minLength(2)
param webAppNameBackend string
param appServicePlanResourceGroupName string
param appServicePlanName string
param vnetResourceGroupName string
param vnetName string

@description('The Runtime stack of current web app')
param linuxFxVersionBe string = 'php|8.2'

@description('Location for all resources.')
var location = resourceGroup().location
var subnetName = 'WEB'

module appServicePlanModule '../../_shared_dev/app_service_plans/asp.bicep' = {
  scope: resourceGroup(appServicePlanResourceGroupName)
  name: 'appServicePlanModule'
  params: {
    appServicePlanName: appServicePlanName
  }
}

resource vnetResource 'Microsoft.Network/virtualNetworks@2022-09-01' existing = {
  scope: resourceGroup(vnetResourceGroupName)
  name: vnetName
}

var subnetResourceId = '${vnetResource.id}/subnets/${subnetName}'

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
      appCommandLine: 'curl -o /home/default https://raw.githubusercontent.com/ossentoo/nginx/main/default;curl -o /home/start.sh https://raw.githubusercontent.com/ossentoo/nginx/main/start.sh;chmod +x /home/start.sh;/home/start.sh'
    }    
    httpsOnly: true
    vnetRouteAllEnabled: true    
  }
  identity: {
    type: 'SystemAssigned'
  }
}

// Backend certificate
