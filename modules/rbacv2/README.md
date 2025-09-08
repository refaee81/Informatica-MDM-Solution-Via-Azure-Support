<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | n/a |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

This code is creating a role assignment in Azure. The data blocks are setting up the principal that will be assigned the role. The first data block is for a service principal, the second is for a user, and the third is for a group. The resource block is creating the role assignment with the scope and role definition name specified in variables, as well as the principal ID which is determined by whichever of the three data blocks evaluates to true. The lifecycle block is ensuring that any changes to the principal ID will be ignored.

## Resources

| Name | Type |
|------|------|
| [azurerm_role_assignment.assignment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azuread_group.group](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azuread_service_principal.spn](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/service_principal) | data source |
| [azuread_user.user](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/user) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_principal"></a> [principal](#input\_principal) | n/a | `string` | n/a | yes |
| <a name="input_role"></a> [role](#input\_role) | n/a | `any` | n/a | yes |
| <a name="input_scope"></a> [scope](#input\_scope) | n/a | `string` | n/a | yes |
| <a name="input_type"></a> [type](#input\_type) | n/a | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->