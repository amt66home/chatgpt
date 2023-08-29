<#
 Author: AM Taylor
 Date:   29 August 2023
 Desc:   Change the backup storage redundancy on a managed instance
>#

# Authenticate to Azure
Connect-AzAccount

# Set variables
$resourceGroupName = "your-resource-group-name"
$instanceName = "your-managed-instance-name"
$subscriptionId = "your-subscription-id"
$backupStorageRedundancy = "Geo"

# Set the context to the correct subscription
Set-AzContext -SubscriptionId $subscriptionId

# Get the Managed Instance
$managedInstance = Get-AzSqlInstance -ResourceGroupName $resourceGroupName -Name $instanceName

# Configure backup storage redundancy
$backupConfiguration = @{
    Location = $managedInstance.Location
    ResourceGroupName = $resourceGroupName
    ManagedInstanceName = $instanceName
    BackupStorageRedundancy = $backupStorageRedundancy
}

Set-AzSqlInstanceBackup -ResourceGroupName $resourceGroupName -InstanceName $instanceName -BackupStorageRedundancy $backupStorageRedundancy

Write-Host "Backup storage redundancy on Azure SQL Managed Instance '$instanceName' has been changed to '$backupStorageRedundancy'."
```

Replace the placeholders (`your-resource-group-name`, `your-managed-instance-name`, `your-subscription-id`) with your actual values. The `$backupStorageRedundancy` variable is set to "Geo" in the script, but you can change it to "Local" if you want to use local redundancy instead.

Please be cautious while executing any script that makes changes to your Azure resources, especially a critical component like backups. It's always recommended to test such scripts in a non-production environment before applying them to production systems.
