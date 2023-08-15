# Install and import the Az module
Install-Module -Name Az -Force
Import-Module Az

# Authenticate to Azure (You may need to replace these with your actual credentials)
$tenantId = "<Your Tenant ID>"
$clientId = "<Your Application Client ID>"
$clientSecret = "<Your Application Client Secret>"
$subscriptionId = "<Your Subscription ID>"

$securePassword = ConvertTo-SecureString $clientSecret -AsPlainText -Force
$credential = New-Object PSCredential($clientId, $securePassword)

Connect-AzAccount -ServicePrincipal -Tenant $tenantId -Credential $credential

# Specify the Key Vault details
$keyVaultName = "<Your Key Vault Name>"
$secretName = "<Your Secret Name>"

# Get the secret value (which should be the SAS token)
$secretValue = (Get-AzKeyVaultSecret -VaultName $keyVaultName -Name $secretName).SecretValueText

# SQL Server details
$serverName = "<Your SQL Server Name>"
$databaseName = "<Your Database Name>"
$credentialName = "MyAzureSASCredential"  # Change this to your desired credential name

# Connect to the SQL Server using the SAS token
$connectionString = "Server=$serverName.database.windows.net;Database=$databaseName;Credential=$credentialName;"

# Create the SQL Server credential using the SAS token
$credentialQuery = "CREATE DATABASE SCOPED CREDENTIAL [$credentialName] WITH IDENTITY = 'SHARED ACCESS SIGNATURE', SECRET = '$secretValue';"

Invoke-SqlCmd -ServerInstance $serverName -Database $databaseName -Query $credentialQuery -Username $clientId -Password $clientSecret -ConnectionTimeout 30
