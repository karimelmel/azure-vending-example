targetScope = 'subscription'

@description('Name of the Budget. It should be unique within a subscription.')
param budgetName string

@description('The total amount of cost or usage to track with the budget in NOK')
param budgetAmount int

@description('The time covered by a budget. Tracking of the amount will be reset based on the time grain.')
@allowed([
  'Monthly'
  'Quarterly'
  'Annually'
])
param budgetTimeGrain string = 'Monthly'

@description('The start date must be first of the month in YYYY-MM-DD format. Future start date should not be more than three months. Past start date should be selected within the timegrain preiod.')
param budgetStartDate string

@description('Threshold value associated with a notification. Notification is sent when the cost exceeded the threshold. It is always percent and has to be between 0.01 and 1000.')
param budgetThreshold int = 100

@description('Threshold value associated with a notification. Notification is sent when the cost exceeded the threshold. It is always percent and has to be between 0.01 and 1000.')
param budgetForecastedThreshold int = 110

@description('The list of contact roles to send the budget notification to when the threshold is exceeded.')
param budgetContactRoles array = []

@description('The list of email addresses to send the budget notification to when the threshold is exceeded.')
param budgetContactEmails array = []

@description('The list of action groups to send the budget notification to when the threshold is exceeded. It accepts array of strings.')
param budgetContactGroups array = []

resource budget 'Microsoft.Consumption/budgets@2021-10-01' = {
  name: budgetName
  properties: {
    timePeriod: {
      startDate: budgetStartDate
    }
    timeGrain: budgetTimeGrain
    amount: budgetAmount
    category: 'Cost'
    notifications: {
      NotificationForExceededBudget1: {
        enabled: true
        operator: 'GreaterThan'
        threshold: budgetThreshold
        contactEmails: budgetContactEmails
        contactRoles: budgetContactRoles
        contactGroups: budgetContactGroups
      }
      NotificationForExceededBudget2: {
        enabled: true
        operator: 'GreaterThan'
        threshold: budgetForecastedThreshold
        contactEmails: budgetContactEmails
        contactRoles: budgetContactRoles
        contactGroups: budgetContactGroups
        thresholdType: 'Forecasted'
      }
    }
  }
}
