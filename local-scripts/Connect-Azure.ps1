param(
    [Parameter()]
    [string]$TenantId = "$($env:AZURE_TENANT_ID)"
)

Write-Verbose "Connecting to Azure with TenantId: $TenantId and SubscriptionId: $SubscriptionId" -Verbose:$true
Connect-AzAccount -TenantId $TenantId -UseDeviceAuthentication | Out-Null

$context = Get-AzContext

Write-Verbose "Connected to Azure with with user: $($context.Account.Id) TenantId: $($context.Tenant.Id) SubscriptionName: $($context.Subscription.Name) SubscriptionId: $($context.Subscription.Id)" -Verbose:$true
