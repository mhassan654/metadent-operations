@description('The SKU of App Service Plan ')
param sku string = 'P0V3'
param appServicePlanName string

@description('Location for all resources.')
param location string = resourceGroup().location


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
