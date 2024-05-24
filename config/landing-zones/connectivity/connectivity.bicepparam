using '../../../infra-as-code/main.bicep'

param connectivitySubscriptionId = readEnvironmentVariable('CONNECTIVITY_SUBSCRIPTION_ID')
param connetivityDnsResourceGroupName = readEnvironmentVariable('CONNECTIVITY_PUBLIC_DNS_RESOURCE_GROUP')
param topLevelManagementGroupPrefix = readEnvironmentVariable('TOP_LEVEL_MG_PREFIX')

param archetype = 'connectivity'

param businessUnit = 'group'
param subscriptionPurpose = 'connectivity'
param environment = 'p'
param locationShortName = 'glb'

param subscriptionAliasName = 'group-connectivity-glb'
param subscriptionDisplayName = 'group-connectivity-glb'

param tags = {
  Owner: 'example@example.com'
  Criticality: 'Mission-critical'
  Business: 'Example 1'
  Environment: 'Production'
}

param budgetAmount = 100000

param budgetContactEmails = [
  'example@example.com'
]
