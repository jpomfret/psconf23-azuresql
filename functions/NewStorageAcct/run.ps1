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

if ($name) {
    $body = "Hello, $name. This HTTP triggered function executed successfully - v2."
}

Set-AzContext -Tenant $env:AZ_TENANT_ID -SubscriptionId $env:AZ_SUBSCRIPTION_ID

New-AzStorageAccount -ResourceGroupName psconfeu-rg -Name $name -Location uksouth -SkuName Standard_GRS

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = [HttpStatusCode]::OK
    Body = $body
})
