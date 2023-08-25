# Replace these variables with your values
$resourceGroupName = "your-resource-group"
$managedInstanceName = "your-managed-instance-name"
$location = "your-location"

# Sign in to Azure
Connect-AzAccount

# Get the managed instance
$managedInstance = Get-AzSqlInstance -ResourceGroupName $resourceGroupName -Name $managedInstanceName -ServerName $managedInstanceName

# Configure backup retention to geo-redundant storage
$backupConfig = @{
    Location = $location
    ResourceGroupName = $resourceGroupName
    ManagedInstanceName = $managedInstanceName
    RetentionPolicyType = "GeoRedundant"
}

# Update the backup retention policy
Set-AzSqlInstanceBackup -BackupRetention $backupConfig
