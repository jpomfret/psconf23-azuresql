using namespace System.Net

param($storageChanges)

Write-Host "TRIGGERED the Function"
# The output is used to inspect the trigger binding parameter in test methods.
# Use -Compress to remove new lines and spaces for testing purposes.
$changesJson = $storageChanges | ConvertTo-Json -Compress

Write-Host "SQL Changes: $changesJson"