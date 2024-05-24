using '../../../infra-as-code/main.bicep'

param connectivitySubscriptionId = readEnvironmentVariable('CONNECTIVITY_SUBSCRIPTION_ID')
param connetivityDnsResourceGroupName = readEnvironmentVariable('CONNECTIVITY_PUBLIC_DNS_RESOURCE_GROUP')
param topLevelManagementGroupPrefix = readEnvironmentVariable('TOP_LEVEL_MG_PREFIX')

param archetype = 'identity'

param businessUnit = 'group'
param subscriptionPurpose = 'identity'
param environment = 'p'
param locationShortName = 'glb'

param subscriptionAliasName = 'group-identity'
param subscriptionDisplayName = 'group-identity-glb'

param tags = {
  Owner: 'user1@example.com'
  Criticality: 'High'
  Business: 'Example 2'
  Environment: 'Production'
}

param budgetAmount = 10000

param budgetContactEmails = [
  'user1@example.com'
  'user2@example.com'
  'user3@example.com'
  'user4@example.com'
]
