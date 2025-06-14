# Secon Cyber | Microsoft Sentinel | Deployment Automation

This project automates the deployment and initial configuration of Microsoft Sentinel environments. It is ideal for **Proof of Concept (PoC)**, **customer onboarding**, or **MSSP-managed SOC** scenarios.

---

## 🚀 What This Automation Does

- Creates a **Resource Group**
- Deploys a **Log Analytics Workspace**
- Installs **Microsoft Sentinel** on the workspace
- Configures:
  - **Log retention**
  - [**Daily cap**](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/daily-cap)
  - **Commitment tiers**
- Enables **UEBA** (User & Entity Behavior Analytics) with Azure AD and/or on-prem AD
- Enables **health diagnostics** for:
  - Analytics Rules
  - Data Connectors
  - Automation Rules
- Deploys **Content Hub solutions**
- Enables the following **Data Connectors**:
  - Azure Active Directory *(tenant-scope only)*
  - Azure AD Identity Protection
  - Azure Activity
  - Dynamics 365
  - Microsoft 365 Defender
  - Microsoft Defender for Cloud
  - Microsoft Insider Risk Management
  - Microsoft Power BI
  - Microsoft Project
  - Office 365
  - Threat Intelligence Platforms
- Deploys **Scheduled and Near-Real-Time analytics rules** from:
  - Enabled Content Hub solutions
  - Selected Data Connectors
- Includes Automation Rule to **auto-close noisy incidents** (e.g., MFA Deny)

⏱ **Estimated Time to Deploy**:
- With analytics rules: ~10 minutes  
- Without analytics rules: ~2 minutes

---

## ✅ Prerequisites

- An **Azure Subscription**
- **Microsoft Sentinel Contributor** role (minimum)
- Some data connectors require specific licenses (see table below)

---

## 🔧 Deployment

| Deployment Scope       | Deploy | Required Permission |
|------------------------|--------|---------------------|
| **Subscription Scope** | [![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FJudeMagayon%2FAzure-Sentinel%2F3e2ad3ef962b54caed5ad8cdc6c677819076ed93%2FAzure%2520Sentinel%2520V2%2Fazuredeploy.json/createUIDefinitionUri/https%3A%2F%2Fraw.githubusercontent.com%2FJudeMagayon%2FAzure-Sentinel%2F3e2ad3ef962b54caed5ad8cdc6c677819076ed93%2FAzure%2520Sentinel%2520V2%2FcreateUiDefinition.json) | Microsoft Sentinel Contributor |

---

## 🔌 Supported Data Connectors

| Data Connector                             | License            | Required Permissions            | Ingestion Cost |
|--------------------------------------------|--------------------|----------------------------------|----------------|
| Azure Active Directory *(tenant only)*     | Any AAD license    | Global Admin / Security Admin   | **Billed**     |
| Azure AD Identity Protection               | AAD Premium P2     | Global Admin / Security Admin   | **Free**       |
| Azure Activity                             | None               | Subscription Reader             | **Free**       |
| Dynamics 365                               | D365 License       | Global Admin / Security Admin   | **Billed**     |
| Microsoft 365 Defender                     | M365D License      | Global Admin / Security Admin   | **Free**       |
| Microsoft Defender for Cloud               | MDC License        | Security Reader                 | **Free**       |
| Insider Risk Management                    | IRM License        | Global Admin / Security Admin   | **Free**       |
| Microsoft Power BI                         | Power BI License   | Global Admin / Security Admin   | **Billed**     |
| Microsoft Project                          | Project License    | Global Admin / Security Admin   | **Billed**     |
| Office 365                                 | None               | Global Admin / Security Admin   | **Free**       |
| Threat Intelligence Platforms              | None               | Global Admin / Security Admin   | **Billed**     |

---

## 📁 Repository Structure (Optional Section)

