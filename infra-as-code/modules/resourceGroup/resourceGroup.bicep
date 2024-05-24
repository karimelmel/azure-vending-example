targetScope = 'subscription'

@description('The resource name')
param resourceGroupName string

@description('The location of the resource group. It cannot be changed after the resource group has been created. It must be one of the supported Azure locations.')
param location string

@description('The tags attached to the resource group')
param tags object = {}

@description('The resource group properties')
param properties object = {}

resource resourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: resourceGroupName
  location: location
  tags: tags
  properties: properties
}
