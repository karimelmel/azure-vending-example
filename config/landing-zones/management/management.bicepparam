using '../../../infra-as-code/main.bicep'

param connectivitySubscriptionId = readEnvironmentVariable('CONNECTIVITY_SUBSCRIPTION_ID')
param connetivityDnsResourceGroupName = readEnvironmentVariable('CONNECTIVITY_PUBLIC_DNS_RESOURCE_GROUP')
param topLevelManagementGroupPrefix = readEnvironmentVariable('TOP_LEVEL_MG_PREFIX')

param archetype = 'management'

param businessUnit = 'group'
param subscriptionPurpose = 'management'
param environment = 'p'
param locationShortName = 'glb'

param subscriptionAliasName = 'group-management'
param subscriptionDisplayName = 'group-management-glb'

param tags = {
  Owner: 'user@example.com'
  Criticality: 'High'
  Business: 'Example 3'
  Environment: 'Production'
}

param budgetAmount = 100000

param budgetContactEmails = [
  'user@example.com'
]
