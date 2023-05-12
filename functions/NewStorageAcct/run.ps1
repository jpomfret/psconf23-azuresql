using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."

# Interact with query parameters or the body of the request.
$name = $Request.Query.Name

#if (-not $name) {
#    $name = $Request.Body.Name
#}

$body = [PSCustomObject]@{
    StorageAccountName = $Name
    Test = 'Hi'
}

New-AzStorageAccount -ResourceGroupName psconfeu-rg -Name $name -Location uksouth -SkuName Standard_LRS

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = [HttpStatusCode]::OK
    Body = (ConvertTo-Json $body)
})
