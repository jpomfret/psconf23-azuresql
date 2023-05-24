using namespace System.Net

param($stgAcctChanges)

Import-Module Az.Storage
# The output is used to inspect the trigger binding parameter in test methods.
# Use -Compress to remove new lines and spaces for testing purposes.
#$changesJson = $stgAcctChanges | ConvertTo-Json -Compress
#Write-Host "SQL Changes: $changesJson"

try {

    #$stgAcctChanges[0]
    #$stgAcctChanges | Measure-Object
    

    $logMessage = 'Creating storage account(s): '
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
        $results = New-AzStorageAccount @splatStorage -ErrorAction Stop
        $logMessage += ('{0} created - {1}; ' -f $change.Item.storageAcctName, $results.ProvisioningState)
    }

    $body = [PSCustomObject]@{ 
        logMessage = $logMessage
    }
} catch {
    
    write-error $_.Exception
    #write-error $_.Exception.Message
    $body = [PSCustomObject]@{
        logMessage = ('{0} - {1}' -f $results.ProvisioningState, $_.Exception.Message)
    }
} finally {
    # Push output to the log table.
    Push-OutputBinding -Name log -Value $body
    
}