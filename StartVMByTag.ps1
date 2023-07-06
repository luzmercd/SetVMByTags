# LabGroup autostart

# Log into the account
#Ensures you do not inheritan AzContext in your workbook
Disable-AzContextAutosave -Scope Process

#Connect to Azure with system-assigned managed identity
$AzContext = (Connect-AzAccount -Identity).context 

# set and store context
$AzureContext = Set-AzContext -SubscriptionName $AzureContext.Subscription  -DefaultProfile $AzureContext 

#Get the VM's
$vms = get-azvm | Where-Object {$_.Tags['LabGroup'] -eq 'autostart'}

#start shut down VM's 
foreach ($vm in $vms) {
    $status = (get-azvm -Name $vm.Name -ResourceGroupName $vm.ResourceGroupName -status).statuses[1].code
    if ($status -ne 'PowerState/running') {
        Write-Output "Starting VM $vm.name "
        start-azvm $vm.Name -ResourceGroupName $vm.ResourceGroupName -NoWait
    }
}