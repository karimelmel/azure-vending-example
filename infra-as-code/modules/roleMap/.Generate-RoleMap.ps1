<#
.Description
Generates a file rolemap.json that contains a map of the role defintion name and
the corresponding role defintion ID for all Azure roles. The output roleMap.json
is used by our bicep code so that we can use role names instead of role
definition IDs in the parameters files. It can be necessary to run this script
if Microsoft Azure release new roles.

To update roleMap.json run it first locally then push the updated roleMap.json
to remote.
#>

$roles = @()

# Get all roles at mg-example root scope
$roles += Get-AzRoleDefinition -Scope "/providers/Microsoft.Management/managementGroups/mg-example" | Select-Object Name, Id

# Initialize an empty custom object
$jsonObject = @{}

# Populate the custom object with key-value pairs
$roles | ForEach-Object {
    $jsonObject[$_.Name] = @{
        "id" = $_.Id
    }
}

# Sort the result by role name
$roles = $roles | Sort-Object Name

# Convert the custom object to JSON format
$jsonOutput = $jsonObject | ConvertTo-Json -Depth 5

# Display the JSON output
Write-Output $jsonOutput > roleMap.json
