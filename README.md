# Terraform Azure Linux Web App

A learning-focused Terraform project that provisions Azure infrastructure for a Linux Web App, including an App Service Plan, Storage Account, Key Vault, Azure authentication settings (OIDC), and remote Terraform state.

The project is being built to learn practical Cloud and DevOps concepts, including:

- Terraform modules
- Remote state
- OpenID Connect (OIDC) authentication
- Managed identities
- Azure RBAC
- Azure Key Vault
- GitHub Actions deployment workflows

## Resources

This project provisions or references:

- An existing Azure Resource Group
- Linux App Service Plan (P1v3)
- Azure Linux Web App
- Azure Storage Account
- Private Blob container
- Storage SAS token for Blob Storage logging/backup configuration
- Azure Key Vault configured for Azure RBAC authorization
- Azure Entra ID authentication for the Web App
- Terraform remote state stored in Azure Blob Storage

## Module Structure

```text
.
├── main.tf                  # Root module and Web App resources
├── providers.tf             # Azure provider and OIDC configuration
├── backend.tf               # Azure Blob remote-state backend
├── data/                    # Existing Azure resource/data lookups
|    |_ dataMain.tf          # Contains Main.tf file for data module  
|    |_ dataOut.tf           # Contains the output of the module to be referenced within the root.
├── resource/                # Storage Account, Blob container, and SAS generation
|    |_ resourceMain.tf      # Contains Main.tf file for resource module  
|    |_ resourceOut.tf       # Contains the output of the module to be referenced within the root.
|    |_ resourceVar.tf       # Contains the variables of the resource module
└── KeyVault/                # Azure Key Vault module
|    |_ keyMain.tf           # Contains Main.tf file for KeyVault module  
|    |_ KeyOut.tf            # Contains the output of the module to be referenced within the root.
|    |_ KeyVar.tf            # Contains the variables of the KeyVault module
```

## Data Module

The **data** module reads existing Azure resources and tenant information. It does **not** create any infrastructure.

It retrieves:

- Existing Resource Group name
- Resource Group location
- Current Azure identity information
- Tenant ID
- Subscription ID
- Client ID
- Object ID

## Resource Module

The **resource** module creates:

- Azure Storage Account
- Private Blob container
- Account SAS query string for Blob access. The SAS query string is exported as a **sensitive Terraform output**.


## Key Vault Module

The **KeyVault** module creates a **Standard Azure Key Vault** with Azure RBAC enabled.

The vault is intended to store application secrets such as:

- Database passwords
- Third-party API keys
- OAuth client secrets
- Certificates
- Connection strings (when Managed Identity cannot be used)


## Design Decisions

### OpenID Connect (OIDC)

GitHub Actions authenticates to Azure through **OpenID Connect (OIDC)** federation instead of using client secrets. This avoids storing Azure client secrets in GitHub.

Use the link: https://api.github.com/repos/<Org-Name>/<Repo-Name>

This link would give the information regarding the Organization ID along with Repo ID, which is currently not exposed to the UI.

GitHub Variables should contain only non-sensitive configuration values:

- `ARM_CLIENT_ID`
- `ARM_TENANT_ID`
- `ARM_SUBSCRIPTION_ID`

Actual secrets should be stored in **Azure Key Vault**, not in GitHub Secrets.

### Azure Key Vault Authorization

The Key Vault uses Azure RBAC instead of Key Vault access policies.

```terraform
rbac_authorization_enabled = true
```

## Remote Terraform State

Terraform state is stored in an Azure Storage Account backend.

### Important Considerations

- A SAS token is a bearer credential.
- Marking an output as `sensitive` hides it from normal CLI output but **does not remove it from the Terraform state file**.
- The remote Terraform state backend should be protected using least-privilege Azure RBAC.
- SAS tokens should have only the minimum required permissions.
- SAS tokens should have a short expiration period.

## Prerequisites

Before deploying, ensure you have:

- Terraform installed
- An Azure subscription
- An existing Azure Resource Group
- An Azure Storage Account and Blob container for the Terraform backend
- An Azure App Registration configured with federated OIDC credentials
- Required Azure RBAC role assignments

## Future Improvements

Planned enhancements include:

- Add Terraform input variables
- Support environment-specific configuration
- Add variable validation rules
- Expand GitHub Actions CI/CD pipeline
- Add monitoring and diagnostics
- Improve module reusability

## Security Notes

- Avoid storing secret values directly in Terraform resources.
- Terraform stores resource values inside the state file.
- Store secrets in Azure Key Vault whenever possible.
- Prefer Managed Identity over secrets when supported.
