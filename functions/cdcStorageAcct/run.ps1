using namespace System.Net
#
## Input bindings are passed in via param block.
#param($Request, $TriggerMetadata)
#
## Write to the Azure Functions log stream.
#Write-Host "PowerShell HTTP trigger function processed a request."
#
## Interact with query parameters or the body of the request.
#$name = $Request.Query.Name
#if (-not $name) {
#    $name = $Request.Body.Name
#}
#
#$body = "This HTTP triggered function executed successfully. Pass a name in the query string or in the request body for a personalized response."
#
#if ($name) {
#    $body = "Hello, $name. This HTTP triggered function executed successfully."
#}
#
## Associate values to output bindings by calling 'Push-OutputBinding'.
#Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
#    StatusCode = [HttpStatusCode]::OK
#    Body = $body
#})

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
    #$body = [PSCustomObject]@{
    #    StorageAccountName = $Name
    #    ProvisioningState  = $results.ProvisioningState
    #    CreationTime       = $results.CreationTime
    #    Tags               = $results.Tags
    #}
    $body = [PSCustomObject]@{ 
        logMessage = ('{0} created - {1}' -f $order.storageAcctName, $results.ProvisioningState)
    }
} catch {
    $body = [PSCustomObject]@{
        logMessage = ('{0} - {1}' -f $results.ProvisioningState, $_.Exception.Message)
    }
} finally {
    # Push output to the log table.
    Push-OutputBinding -Name log -Value $body
}