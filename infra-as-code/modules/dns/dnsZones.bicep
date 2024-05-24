targetScope = 'resourceGroup'

metadata name = 'Azure DNS zones'
metadata description = 'Azure DNS is a hosting service for DNS domains that provides name resolution.'

@description('Specifies the dns zone name. This parameter value is the subdomain part of the zone name which format is: <subdomain>.<environment>-lz.az.example.com')
param dnsZoneName string

@allowed([
  'd'
  'p'
  'q'
  't'
])
@description('Specifies resource environment')
param environment string = 'd'

@description('Specifies the parent dns zone name. This parameter value is the domain part of the zone name. By default, value is calculated with the parameter environment as: <environment>-lz.az.example.com')
param parentDnsZoneName string = '${environment}-lz.az.example.com'

@description('The TTL (time-to-live) of the records in the NS record set')
param ttl int = 3600

@description('Tags to assign to the resources used in dns-zones.')
param tags object = {}

@allowed([
  'Public'
  'Private'
])
@description('The type of this DNS zone, default set to Public.')
param zoneType string = 'Public'

@description('Connectivity subscription Id. Used to update NS records in parent zone.')
param connectivitySubscriptionId string

@description('Existing connectivity DNS resource group name. Used to update NS records in parent zone.')
param connetivityDnsResourceGroupName string


resource dnsZones 'Microsoft.Network/dnsZones@2018-05-01' = {
  name: '${dnsZoneName}.${parentDnsZoneName}'
  location: 'global'
  tags: tags
  properties: {
    zoneType: zoneType
  }
}

@description('Module to create NS records in the parent DNS zone containing NS server names from child. Module is necessary due to a current bicep limitation that is not possible to reference resources that are not created before the deployment')
module childDnsZoneRecord 'modules/childDnsZoneRecord.bicep' = if (!empty(parentDnsZoneName)) {
  name: '${dnsZoneName}.${parentDnsZoneName}'
  scope: resourceGroup(connectivitySubscriptionId, connetivityDnsResourceGroupName)
  params: {
    parentDnsZoneName: parentDnsZoneName
    childDnsZoneName: dnsZoneName
    dnszonesServers: dnsZones.properties.nameServers
    ttl: ttl
  }
}

@description('Parent Id for DNS zone')
output dnsZonesId string = dnsZones.id
