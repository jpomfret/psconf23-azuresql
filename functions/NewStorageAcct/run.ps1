using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."

try {

    $name = $Request.Query.Name
    $sku = 'Standard_LRS'
    $location = 'uksouth'

    $splatStorage = @{
        Name = $name
        ResourceGroupName = 'psconfeu-rg'
        Location = $location
        SkuName = $sku
        Tag = @{ 'CreatedBy' = 'AzFunc' }
    }
    $results = New-AzStorageAccount @splatStorage

    $body = [PSCustomObject]@{
        StorageAccountName = $Name
        ProvisioningState =  $results.ProvisioningState
        CreationTime = CreationTime
    }
} catch {
    $body = [PSCustomObject]@{
        Error = $_.Exception.Message
        #Success = $false
        ProvisioningState =  $results.ProvisioningState
    }
} finally {

    # Associate values to output bindings by calling 'Push-OutputBinding'.
    Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode = [HttpStatusCode]::OK
        Body = (ConvertTo-Json $body)
    })

}