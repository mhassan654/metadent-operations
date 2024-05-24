@description('P0V3 app service plan attached to Uriel')
param sku string = 'P0v3'

@description('uriel-be-prd-01 rsource location')
param location string = resourceGroup().location

var appServicePlanName = 'asp-metadent-dev'

resource appServicePlan 'Microsoft.Web/serverfarms@2023-12-01'={
  name: appServicePlanName
  location:location
  sku:{
    name: sku
  }
  kind:'linux'
  properties:{
    reserved:true
  }
}

output appServicePlanId string = appServicePlan.id
