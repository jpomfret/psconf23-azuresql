using namespace System.Net

param($stgAcctChanges)
# The output is used to inspect the trigger binding parameter in test methods.
# Use -Compress to remove new lines and spaces for testing purposes.
$changesJson = $stgAcctChanges | ConvertTo-Json -Compress
Write-Host "SQL Changes: $changesJson"

try {
    # foreach change create a storage account
    foreach ($change in $stgAcctChanges) {
        Write-Host ("Change operation: {0}" -f $change.Operation)
        Write-Host ("Create a storage account ID: {0}, Name: {1}" -f $change.Item.storageAcctId, $change.Item.storageAcctName)
        
        # defaults - these could come from table too
        $sku = 'Standard_LRS'
        $location = 'uksouth'

        $splatStorage = @{
            Name              = $change.Item.storageAcctName
            ResourceGroupName = 'psconfeu-rg'
            Location          = $location
            SkuName           = $sku
            Tag               = @{ 'CreatedBy' = 'AzFuncV2' }
        }
        $results = New-AzStorageAccount @splatStorage
    }

    $body = [PSCustomObject]@{ 
        logMessage = ('{0} created - {1}' -f $order.storageAcctName, $results.ProvisioningState)
    }
    $status = [HttpStatusCode]::OK
} catch {
    $body = [PSCustomObject]@{
        logMessage = ('{0} - {1}' -f $results.ProvisioningState, $_.Exception.Message)
    }
    $status = [HttpStatusCode]::BadRequest
} finally {
    # Push output to the log table.
    Push-OutputBinding -Name log -Value $body

    Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode = $status
        Body = (ConvertTo-Json $body)
    })
}