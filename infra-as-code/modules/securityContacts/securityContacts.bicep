targetScope = 'subscription'

@sys.description('List of email addresses which will get notifications from Microsoft Defender for Cloud by the configurations defined in this security contact.	')
param emails string

@sys.description('Defines whether to send email notifications from Microsoft Defender for Cloud to persons with specific RBAC roles on the subscription.')
param notificationsByRole array

@sys.description('Defines if email notifications will be sent about new security alerts')
param securityContactAlertState string

@sys.description('Defines the minimal alert severity which will be sent as email notifications.')
param minimalSeverity string

resource securityContacts 'Microsoft.Security/securityContacts@2020-01-01-preview' = {
  name: 'default'
  properties: {
    alertNotifications: {
      minimalSeverity: minimalSeverity
      state: securityContactAlertState
    }
    emails: emails
    notificationsByRole: {
      roles: notificationsByRole
      state: 'On'
    }
  }
}
