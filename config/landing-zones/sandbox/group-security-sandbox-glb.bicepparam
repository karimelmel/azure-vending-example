using '../../../infra-as-code/main.bicep'

param connectivitySubscriptionId = readEnvironmentVariable('CONNECTIVITY_SUBSCRIPTION_ID')
param connetivityDnsResourceGroupName = readEnvironmentVariable('CONNECTIVITY_PUBLIC_DNS_RESOURCE_GROUP')
param topLevelManagementGroupPrefix = readEnvironmentVariable('TOP_LEVEL_MG_PREFIX')

param archetype = 'sandbox'

param businessUnit = 'group'
param subscriptionPurpose = 'security'
param environment = 'sandbox'
param locationShortName = 'glb'

param tags = {
  Owner: 'example@example.com'
  Criticality: 'Unsupported'
  Business: 'Example 1'
  Environment: 'Sandbox'
  ExpirationDate: '2024-04-01'
}

param subscriptionRoleAssignments = [
  {
    principalId: '7b3b3168-eb64-4334-98e3-21a4b861f67d'
    definition: 'Owner'
    relativeScope: ''
  }
  {
    principalId: ''
    definition: 'Owner'
    relativeScope: ''
  }
  {
    principalId: ''
    definition: 'Owner'
    relativeScope: ''
  }
  {
    principalId: ''
    definition: 'Owner'
    relativeScope: ''
  }
]


param budgetContactEmails = [
  'user1@example.com'
]

param subscriptionAliasName = 'group-security-sandbox'
