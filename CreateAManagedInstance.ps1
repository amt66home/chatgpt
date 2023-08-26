# Set your Azure subscription and resource details
$subscriptionName = "YourSubscriptionName"
$resourceGroupName = "YourResourceGroupName"
$location = "East US"  # Change to your desired region
$instanceName = "YourManagedInstanceName"
$adminUsername = "AdminUsername"
$adminPassword = "AdminPassword"
$vnetName = "YourVNetName"
$subnetName = "YourSubnetName"
$nsgName = "YourNSGName"  # Specify the name of the NSG

# Log in to Azure
Connect-AzAccount

# Select the desired subscription
Select-AzSubscription -SubscriptionName $subscriptionName

# Get the NSG object
$nsg = Get-AzNetworkSecurityGroup -ResourceGroupName $resourceGroupName -Name $nsgName

# Add NSG rules for Azure SQL Managed Instance
# Assuming you want to allow SQL Server traffic (1433) and Management traffic (445)
$nsg | Add-AzNetworkSecurityRuleConfig -Name "Allow_SQL" -Priority 1000 -Direction Inbound -Access Allow -Protocol Tcp -SourceAddressPrefix Internet -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 1433
$nsg | Add-AzNetworkSecurityRuleConfig -Name "Allow_Management" -Priority 1100 -Direction Inbound -Access Allow -Protocol Tcp -SourceAddressPrefix Internet -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 445

# Update the NSG with the new rules
$nsg | Set-AzNetworkSecurityGroup

# Create the Azure SQL Managed Instance in an existing subnet with the specified NSG
New-AzSqlInstance -ResourceGroupName $resourceGroupName -Name $instanceName -Location $location -AdministratorLogin $adminUsername -AdministratorLoginPassword $adminPassword -VirtualNetworkName $vnetName -SubnetName $subnetName -ServerNetworkSecurityGroupName $nsgName
