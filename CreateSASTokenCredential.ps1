# Install the AzureRM and SqlServer modules if not already installed
if (-not (Get-Module -ListAvailable -Name Az.Accounts)) {
    Install-Module -Name Az.Accounts -Scope CurrentUser -AllowClobber
}
if (-not (Get-Module -ListAvailable -Name SqlServer)) {
    Install-Module -Name SqlServer -Scope CurrentUser
}

# Sign in to Azure (you may need to modify this based on your authentication method)
Connect-AzAccount

# Define Azure Key Vault information
$KeyVaultName = "YourKeyVaultName"
$SecretName = "YourSecretName"

# Define the SQL Server connection information
$SqlServerInstance = "YourSqlServerInstance"
$DatabaseName = "YourDatabaseName"

# Retrieve the SAS token from Azure Key Vault
$SasTokenSecret = Get-AzKeyVaultSecret -VaultName $KeyVaultName -Name $SecretName
$SasToken = $SasTokenSecret.SecretValueText

# Define the SQL Server credential name
$CredentialName = "YourCredentialName"

# Construct the connection string with the SAS token
$ConnectionString = "Server=tcp:$SqlServerInstance,1433;Database=$DatabaseName;"

# Create the SQL Server credential
$Credential = New-SqlCredential -Name $CredentialName -ConnectionString $ConnectionString -CredentialAzureToken -AzureToken $SasToken

# Output the result
if ($Credential) {
    Write-Host "SQL Server credential '$CredentialName' created successfully."
} else {
    Write-Host "Failed to create the SQL Server credential."
}
