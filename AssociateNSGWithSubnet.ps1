# Connect to your Azure account
Connect-AzAccount

# Define variables
$resourceGroupName = "YourResourceGroupName"
$nsgName = "YourNSGName"
$vnetName = "YourVNetName"
$subnetName = "YourSubnetName"

# Get the NSG and VNet objects
$nsg = Get-AzNetworkSecurityGroup -ResourceGroupName $resourceGroupName -Name $nsgName
$vnet = Get-AzVirtualNetwork -ResourceGroupName $resourceGroupName -Name $vnetName
$subnet = Get-AzVirtualNetworkSubnetConfig -VirtualNetwork $vnet -Name $subnetName

# Associate the NSG with the subnet
$subnet.NetworkSecurityGroup = $nsg
Set-AzVirtualNetwork -VirtualNetwork $vnet

Write-Host "Network Security Group '$nsgName' has been associated with subnet '$subnetName' in VNet '$vnetName'."
