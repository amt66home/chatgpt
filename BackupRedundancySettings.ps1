# Replace these variables with your values
$resourceGroupName = "your-resource-group"
$managedInstanceName = "your-managed-instance-name"

# Sign in to Azure
Connect-AzAccount

# Get the managed instance
$managedInstance = Get-AzSqlInstance -ResourceGroupName $resourceGroupName -Name $managedInstanceName -ServerName $managedInstanceName

# Get the backup configuration
$backupConfig = Get-AzSqlInstanceBackup -ResourceGroupName $resourceGroupName -ManagedInstanceName $managedInstanceName

# Display the current backup redundancy
Write-Host "Backup Redundancy for $managedInstanceName:"
Write-Host "Backup Retention Policy Type: $($backupConfig.BackupRetentionType)"
