# Install the Azure Az module if not already installed
# Install-Module -Name Az -Scope CurrentUser

# Connect to your Azure subscription
Connect-AzAccount

# Define source and destination managed instance details
$sourceInstanceName = "source-instance-name"
$sourceResourceGroup = "source-resource-group"
$destinationInstanceName = "destination-instance-name"
$destinationResourceGroup = "destination-resource-group"
$credentialName = "your-credential-name"

# Get the source credential details
$sourceCredential = Get-AzSqlDatabaseCredential -ResourceGroupName $sourceResourceGroup -ServerName $sourceInstanceName -Name $credentialName

# Create the same credential on the destination managed instance
$destinationCredential = @{
    ServerName = $destinationInstanceName
    ResourceGroupName = $destinationResourceGroup
    Name = $credentialName
    UserName = $sourceCredential.UserName
    Password = $sourceCredential.Password
}

New-AzSqlDatabaseCredential @destinationCredential

Write-Host "Credential '$credentialName' copied from '$sourceInstanceName' to '$destinationInstanceName'"
