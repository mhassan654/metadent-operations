@description('uriel-be-dev-01')
@minLength(2)
param webAppNameBe string = 'uriel-be-dev-01'

@description('uriel-be-dev-01 and uriel-fe-dev-01 runtime stacks')
param linuxFxVersion string = 'php|8.2'

@description('uriel-be-dev-01 rsource location')
param location string = resourceGroup().location

var webAppPortalNameBe = '${webAppNameBe}'

module appServicePlanModule './appserviceplan.bicep'={
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


