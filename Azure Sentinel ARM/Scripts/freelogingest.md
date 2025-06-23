// ===============================
// ARM Template to Deploy Microsoft Sentinel Content Hub Solutions (13 FREE Log Types)
// ===============================
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "workspaceName": {
      "type": "string",
      "metadata": {
        "description": "Name of the existing Log Analytics Workspace."
      }
    },
    "workspaceResourceGroup": {
      "type": "string",
      "metadata": {
        "description": "Resource Group of the existing Log Analytics Workspace."
      }
    }
  },
  "variables": {
    "location": "[resourceGroup().location]"
  },
  "resources": [
    {
      "type": "Microsoft.OperationalInsights/workspaces/providers/contentPackages",
      "apiVersion": "2025-03-01",
      "name": "[concat(parameters('workspaceName'), '/Microsoft.SecurityInsights/azuresentinel.azure-sentinel-solution-azureactivity')]",
      "properties": {
        "contentId": "azuresentinel.azure-sentinel-solution-azureactivity",
        "contentKind": "Solution",
        "contentProductId": "azuresentinel.azure-sentinel-solution-azureactivity",
        "displayName": "Azure Activity",
        "version": "3.0.1"
      }
    },
    {
      "type": "Microsoft.OperationalInsights/workspaces/providers/contentPackages",
      "apiVersion": "2025-03-01",
      "name": "[concat(parameters('workspaceName'), '/Microsoft.SecurityInsights/azuresentinel.azure-sentinel-solution-office365')]",
      "properties": {
        "contentId": "azuresentinel.azure-sentinel-solution-office365",
        "contentKind": "Solution",
        "contentProductId": "azuresentinel.azure-sentinel-solution-office365",
        "displayName": "Office 365",
        "version": "3.0.2"
      }
    },
    {
      "type": "Microsoft.OperationalInsights/workspaces/providers/contentPackages",
      "apiVersion": "2025-03-01",
      "name": "[concat(parameters('workspaceName'), '/Microsoft.SecurityInsights/azuresentinel.azure-sentinel-solution-microsoftdefenderadvancedthreatprotection')]",
      "properties": {
        "contentId": "azuresentinel.azure-sentinel-solution-microsoftdefenderadvancedthreatprotection",
        "contentKind": "Solution",
        "contentProductId": "azuresentinel.azure-sentinel-solution-microsoftdefenderadvancedthreatprotection",
        "displayName": "Microsoft Defender for Endpoint",
        "version": "3.0.2"
      }
    },
    {
      "type": "Microsoft.OperationalInsights/workspaces/providers/contentPackages",
      "apiVersion": "2025-03-01",
      "name": "[concat(parameters('workspaceName'), '/Microsoft.SecurityInsights/azuresentinel.azure-sentinel-solution-microsoftdefenderforidentity')]",
      "properties": {
        "contentId": "azuresentinel.azure-sentinel-solution-microsoftdefenderforidentity",
        "contentKind": "Solution",
        "contentProductId": "azuresentinel.azure-sentinel-solution-microsoftdefenderforidentity",
        "displayName": "Microsoft Defender for Identity",
        "version": "2.0.2"
      }
    },
    {
      "type": "Microsoft.OperationalInsights/workspaces/providers/contentPackages",
      "apiVersion": "2025-03-01",
      "name": "[concat(parameters('workspaceName'), '/Microsoft.SecurityInsights/azuresentinel.azure-sentinel-solution-microsoftcloudappsecurity')]",
      "properties": {
        "contentId": "azuresentinel.azure-sentinel-solution-microsoftcloudappsecurity",
        "contentKind": "Solution",
        "contentProductId": "azuresentinel.azure-sentinel-solution-microsoftcloudappsecurity",
        "displayName": "Microsoft Defender for Cloud Apps",
        "version": "3.0.2"
      }
    },
    {
      "type": "Microsoft.OperationalInsights/workspaces/providers/contentPackages",
      "apiVersion": "2025-03-01",
      "name": "[concat(parameters('workspaceName'), '/Microsoft.SecurityInsights/azuresentinel.azure-sentinel-solution-microsoftdefenderforcloud')]",
      "properties": {
        "contentId": "azuresentinel.azure-sentinel-solution-microsoftdefenderforcloud",
        "contentKind": "Solution",
        "contentProductId": "azuresentinel.azure-sentinel-solution-microsoftdefenderforcloud",
        "displayName": "Microsoft Defender for Cloud",
        "version": "3.0.1"
      }
    },
    {
      "type": "Microsoft.OperationalInsights/workspaces/providers/contentPackages",
      "apiVersion": "2025-03-01",
      "name": "[concat(parameters('workspaceName'), '/Microsoft.SecurityInsights/azuresentinel.azure-sentinel-solution-microsoftdefenderforiot')]",
      "properties": {
        "contentId": "azuresentinel.azure-sentinel-solution-microsoftdefenderforiot",
        "contentKind": "Solution",
        "contentProductId": "azuresentinel.azure-sentinel-solution-microsoftdefenderforiot",
        "displayName": "Microsoft Defender for IoT",
        "version": "3.0.0"
      }
    },
    {
      "type": "Microsoft.OperationalInsights/workspaces/providers/contentPackages",
      "apiVersion": "2025-03-01",
      "name": "[concat(parameters('workspaceName'), '/Microsoft.SecurityInsights/azuresentinel.azure-sentinel-solution-microsoft365defender')]",
      "properties": {
        "contentId": "azuresentinel.azure-sentinel-solution-microsoft365defender",
        "contentKind": "Solution",
        "contentProductId": "azuresentinel.azure-sentinel-solution-microsoft365defender",
        "displayName": "Microsoft Defender XDR",
        "version": "3.0.3"
      }
    }
  ],
  "outputs": {}
}

// ===============================
// README & Deploy Button (Markdown)
// ===============================

/*
# Deploy Microsoft Sentinel Free Content Hub Solutions

This ARM template deploys Microsoft Sentinel Content Hub solutions for the following FREE log types:

1. AzureActivity (Platform Logs)  
2. OfficeActivity (Exchange, SharePoint, Teams)  
3. SecurityAlert (Defender for Endpoint - MDATP)  
4. SecurityAlert (Defender for Identity - AATP)  
5. SecurityAlert (Defender for Cloud Apps - MCAS)  
6. SecurityAlert (Defender for Cloud)  
7. SecurityAlert (Defender for IoT)  
8. SecurityIncident (Microsoft Defender XDR)  
9. SecurityAlert (Microsoft Defender XDR)  
10. SentinelHealth (Automatic)  
11. SecurityAlert (Entra ID Protection - IPC)  
12. Entra ID Sign-in Logs  
13. Azure AD Audit Logs  

## How to Deploy

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FYOUR_REPO_PATH%2Fsentinel-log-ingestion-template.json)

## Prerequisites

- Existing Log Analytics Workspace already connected to Microsoft Sentinel
- Contributor or Microsoft Sentinel Contributor role on the workspace
*/
