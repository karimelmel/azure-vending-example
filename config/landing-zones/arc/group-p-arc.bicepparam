using '../../../infra-as-code/main.bicep'

param connectivitySubscriptionId = readEnvironmentVariable('CONNECTIVITY_SUBSCRIPTION_ID')
param connetivityDnsResourceGroupName = readEnvironmentVariable('CONNECTIVITY_PUBLIC_DNS_RESOURCE_GROUP')
param topLevelManagementGroupPrefix = readEnvironmentVariable('TOP_LEVEL_MG_PREFIX')

param archetype = 'corp'

param businessUnit = 'group'
param subscriptionPurpose = 'arc'
param environment = 'p'
param locationShortName = 'glb'

param tags = {
  Owner: 'example@example.com'
  Criticality: 'High'
  Business: 'Example 1'
  Environment: 'Production'
}

// sp: object id of service principal
param servicePrincipalObjectId = ''

param subscriptionOwners = [
  // user: Example User (example@example.com)
  ''
]

// NOK - threshold for triggering email alert.
param budgetAmount = 50000
param budgetContactEmails = [
  'example2@example.com'
  'example2@example.com'
]

param subscriptionAliasName = 'example1-p-arc'
