param(
    [Parameter()]
    [String]$ManagementGroupId = "$($env:TOP_LEVEL_MG_PREFIX)-landingzones",

    [Parameter()]
    [string]$RoleDefinitionName = "Contributor",

    [Parameter()]
    [string]$Justification = "Local development",

    [Parameter()]
    [int]$DurationInHours = 2
)

$ErrorActionPreference = "Stop"

$roleDefinitionId = (Get-AzRoleDefinition -Name $RoleDefinitionName).Id
$currentContext = Get-AzContext

$inputObject = @{
    Name = [guid]::NewGuid().ToString()
    Scope = "/providers/Microsoft.Management/managementGroups/$ManagementGroupId/"
    ExpirationDuration = "PT${DurationInHours}H"
    ExpirationType = "AfterDuration"
    PrincipalId = (Get-AzAdUser -UserPrincipalName $currentContext.Account.Id).Id
    RequestType = "SelfActivate"
    RoleDefinitionId = "/providers/Microsoft.Management/managementGroups/$ManagementGroupId/providers/Microsoft.Authorization/roleDefinitions/$roleDefinitionId"
    ScheduleInfoStartDateTime = Get-Date -Format o
    Justification = $Justification
    Verbose = $false
}

Write-Verbose "Elevating to role $RoleDefinitionName on management group $ManagementGroupId for $DurationInHours hours" -Verbose:$true
New-AzRoleAssignmentScheduleRequest @inputObject
