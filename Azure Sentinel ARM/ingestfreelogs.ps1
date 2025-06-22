# ====== USER INPUT ======
$workspaceName = Read-Host "Enter your Log Analytics Workspace name"
$resourceGroupName = Read-Host "Enter your Resource Group name"

# ====== Login and Get Context ======
Connect-AzAccount | Out-Null
$context = Get-AzContext
$tenantId = $context.Tenant.Id
$subscriptionId = $context.Subscription.Id

# ====== Get Workspace Resource ID ======
$workspace = Get-AzOperationalInsightsWorkspace -ResourceGroupName $resourceGroupName -Name $workspaceName
if (-not $workspace) {
    Write-Error "Workspace not found. Exiting."
    exit
}
$workspaceId = $workspace.ResourceId

# ====== Get Token for REST API ======
$token = (Get-AzAccessToken).Token
$headers = @{ Authorization = "Bearer $token" }

# ====== Define Connectors to Enable ======
$connectors = @(
    @{
        name = "office365Connector"
        kind = "Office365"
        properties = @{
            tenantId = $tenantId
            dataTypes = @{
                Exchange   = @{ state = "Enabled" }
                SharePoint = @{ state = "Enabled" }
                Teams      = @{ state = "Enabled" }
            }
        }
    },
    @{
        name = "microsoftDefenderATP"
        kind = "MicrosoftDefenderAdvancedThreatProtection"
        properties = @{ tenantId = $tenantId }
    },
    @{
        name = "azureAdvancedThreatProtection"
        kind = "AzureAdvancedThreatProtection"
        properties = @{ tenantId = $tenantId }
    },
    @{
        name = "microsoftThreatProtection"
        kind = "MicrosoftThreatProtection"
        properties = @{ tenantId = $tenantId }
    },
    @{
        name = "microsoftCloudAppSecurity"
        kind = "MicrosoftCloudAppSecurity"
        properties = @{ tenantId = $tenantId }
    }
)

# ====== Enable Each Connector ======
foreach ($connector in $connectors) {
    $uri = "https://management.azure.com$workspaceId/providers/Microsoft.SecurityInsights/dataConnectors/$($connector.name)?api-version=2022-11-01-preview"

    $body = @{
        kind       = $connector.kind
        properties = $connector.properties
    }

    Write-Host "`nConnecting $($connector.kind)..."
    try {
        Invoke-RestMethod -Method PUT -Uri $uri -Headers $headers `
            -Body ($body | ConvertTo-Json -Depth 10) -ContentType "application/json"
        Write-Host "✅ $($connector.kind) connector enabled."
    } catch {
        Write-Warning "⚠️ Failed to connect $($connector.kind): $_"
    }
}

# ====== List All Connected Connectors ======
Write-Host "`n📋 Listing all enabled connectors:"
$listUri = "https://management.azure.com$workspaceId/providers/Microsoft.SecurityInsights/dataConnectors?api-version=2022-11-01-preview"
$response = Invoke-RestMethod -Method GET -Uri $listUri -Headers $headers
$response.value | Select-Object name, kind | Format-Table -AutoSize
