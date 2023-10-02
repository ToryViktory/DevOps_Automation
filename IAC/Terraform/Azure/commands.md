
$RESOURCE_GROUP_NAME="rg-vk-tfstate-eastus"

$STORAGE_ACCOUNT_NAME="tfstatevkeastus"

$ACCOUNT_KEY=(Get-AzStorageAccountKey -ResourceGroupName $RESOURCE_GROUP_NAME -Name $STORAGE_ACCOUNT_NAME)[0].value

$env:ARM_ACCESS_KEY=$ACCOUNT_KEY

Add all secrets to .env

gh secret set -f .env 


az ad app federated-credential create --id f81a846d-d231-48ef-ad13-9ff3e6bc2144 --parameters credential.json
("credential.json" contains the following content)
{
    "name": "terraform-cluster-vk",
    "issuer": "https://token.actions.githubusercontent.com",
    "subject": "repo:ToryViktory/DevOps_Automation:environment:dev",
    "description": "Testing",
    "audiences": [
        "api://AzureADTokenExchange"
    ]
}