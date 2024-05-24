@description('uriel-be-prd-01 and web-lin-prd-01')
@minLength(2)
param webAppNameBe string = 'uriel-be-prd-01'

@description('uriel-be-prd-01 and uriel-fe-prd-01 runtime stacks')
param linuxFxVersion string = 'php|8.1'

@description('uriel-be-prd-01 rsource location')
param location string = resourceGroup().location

var webAppPortalNameBe = '${webAppNameBe}'

module appServicePlanModule '../../../_shared_dev/app_service_plans/sp.bicep'={
  name: 'appServicePlanModule'
}


// define the web app setup
resource webAppPortalBe 'Microsoft.Web/sites@2023-12-01'={
  name: webAppPortalNameBe
  location:location
  kind:'app'
  properties:{
    serverFarmId:appServicePlanModule.outputs.appServicePlanId
    siteConfig:{
      linuxFxVersion: linuxFxVersion
      ftpsState:'FtpsOnly'
    }
    httpsOnly:true
  }
  identity:{type:'SystemAssigned'}
}


