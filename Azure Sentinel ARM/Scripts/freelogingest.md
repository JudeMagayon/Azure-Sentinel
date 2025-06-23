

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

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FJudeMagayon%2FAzure-Sentinel%2Fmain%2FAzure%2520Sentinel%2520ARM%2Fsentinel-log-ingestion-template.json)

## Prerequisites

- Existing Log Analytics Workspace already connected to Microsoft Sentinel
- Contributor or Microsoft Sentinel Contributor role on the workspace
*/
