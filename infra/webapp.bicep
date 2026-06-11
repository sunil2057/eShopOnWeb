param webAppName string 
param sku string = 'P0v4' // 🔥 Changed default from 'S1' to 'P0v4' to fix the quota error
param location string = resourceGroup().location
param costCenterValue string = 'IT-Department' // 🏷️ Added parameter for the required policy tag

var appServicePlanName = toLower('AppServicePlan-${webAppName}')



resource appServicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: appServicePlanName
  location: location
  properties: {
    reserved: true
  }
  sku: {
    name: sku
    tier: 'PremiumV4' 
  }
  tags: {
    CostCenter: costCenterValue 
  }
}

// ... rest of the appService resource remains the same ...
resource appService 'Microsoft.Web/sites@2022-09-01' = {
  name: webAppName
  kind: 'app'
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      linuxFxVersion: 'DOTNETCORE|8.0'
      appSettings: [
        {
          name: 'ASPNETCORE_ENVIRONMENT'
          value: 'Development'
        }
        {
          name: 'UseOnlyInMemoryDatabase'
          value: 'true'
        }
      ]
    }
  }
  tags: {
    CostCenter: costCenterValue // 🏷️ Added required tag
  }
}
