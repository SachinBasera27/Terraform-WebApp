Terraform Azure Linux Web App

A learning-focused Terraform project that provisions Azure infrastructure for a Linux Web App, including an App Service Plan, Storage Account, Key Vault, Azure authentication settings, and remote Terraform state.

The project is being built to learn practical Cloud and DevOps concepts: Terraform modules, remote state, OIDC authentication, managed identities, Azure RBAC, Key Vault, and GitHub Actions deployment workflows.


#Resources
This project provisions or references:
An existing Azure Resource Group.
Linux App Service Plan (P1v3).
Azure Linux Web App.
Azure Storage Account and private Blob container.\br
Storage SAS token for Blob Storage logging/backup configuration.\n
Azure Key Vault configured for Azure RBAC authorization.\br
Azure Entra ID authentication for the Web App.\n
Terraform remote state stored in Azure Blob Storage.\n

Module Structure
.
├── main.tf                  # Root module and Web App resources
├── providers.tf             # Azure provider and OIDC configuration
├── backend.tf               # Azure Blob remote-state backend
├── data/                    # Existing Azure resource/data lookups
├── resource/                # Storage account, container, and SAS generation
└── KeyVault/                # Azure Key Vault module


The data module reads:
Existing Resource Group name and location.
Current Azure identity information.
Tenant ID.
Subscription ID.
Client ID and object ID.
It does not create infrastructure.


The resource module creates:
Storage Account.
Private Blob container.
Account SAS query string for Blob access.
The SAS query string is exported as a sensitive Terraform output.

KeyVault module creates:
The Key Vault module creates a Standard Azure Key Vault with Azure RBAC enabled.
The vault is intended to store application secrets such as:
Database passwords.
Third-party API keys.
OAuth client secrets.
Certificates.
Connection strings, if managed identity cannot be used.

#Design Decisions
OIDC instead of client secrets. GitHub Actions authenticates to Azure through OpenID Connect (OIDC) federation.
This avoids storing an Azure client secret in GitHub Secrets. GitHub Variables should contain non-sensitive configuration such as:
ARM_CLIENT_ID
ARM_TENANT_ID
ARM_SUBSCRIPTION_ID

Actual secret values should be stored in Azure Key Vault, not GitHub Secrets.
Azure Key Vault uses RBAC. The Key Vault uses:
rbac_authorization_enabled = true
Azure RBAC is used instead of Key Vault access policies.


#Remote Terraform state
Terraform state is designed to use an Azure Storage Account backend.

#Important considerations:
A SAS token is a bearer credential.
Marking an output as sensitive hides it from normal CLI output but does not remove it from Terraform state.
The remote Terraform state backend must be protected with least-privilege RBAC.
The SAS should have minimal permissions and a short expiration period.


#Prerequisites
Terraform installed.
Azure subscription and existing Resource Group.
Azure Storage Account/container for Terraform state.
Azure App Registration configured with federated OIDC credentials.
Required Azure RBAC role assignments.

Add Terraform variables, environment-specific values, and validation rules.
Avoid storing secret values directly in Terraform resources because values are saved in Terraform state.
Status
This is a learning project and is under active development. It is not yet production-ready.
