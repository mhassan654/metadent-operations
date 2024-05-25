@description('The SKU of App Service Plan ')
param sku string = 'S1'

@description('Location for all resources.')
param location string = resourceGroup().location

var appServicePlanName = 'ASP-metadentdev-s1'

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

output appServicePlanId string = appServicePlan.id
