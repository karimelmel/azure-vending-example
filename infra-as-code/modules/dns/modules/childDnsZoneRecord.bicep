@description('The Parent DNS Zone name')
param parentDnsZoneName string

@description('The Child DNS Zone name')
param childDnsZoneName string

@description('Name server entries listed in the subdomain (child) zone')
param dnszonesServers array

@description('The TTL (time-to-live) of the records in the record set')
param ttl int = 3600

resource existingParentDnsZones 'Microsoft.Network/dnsZones@2018-05-01' existing = {
  name: parentDnsZoneName
}

resource childDomainDelegation 'Microsoft.Network/dnsZones/NS@2018-05-01' = {
  name: childDnsZoneName
  parent: existingParentDnsZones
  properties: {
    TTL: ttl
    NSRecords: [for childDnsServer in dnszonesServers: {
      nsdname: childDnsServer
    }]
  }
}
