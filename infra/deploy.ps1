Set-AzContext -Subscription bbd50fd8-6a3e-4d6f-8d20-cf6f43c9c461

# create a new resource group
$resourceGroupName = "psconfeu-rg"
$location = "westeurope"
New-AzResourceGroup -Name $resourceGroupName -Location $location

# secure string for password
$securePassword = ConvertTo-SecureString -String 'dbatools.IO1' -AsPlainText -Force

# deploy bicep template
$deploymentName = "psconfeu-deployment"

$splat = @{
    Name                       = $deploymentName
    ResourceGroupName          = $resourceGroupName
    TemplateFile               = '.\infra\main.bicep'
    serverName                 = 'psconfeu-server'
    databaseName               = 'psconfeu-db'
    environment                = 'dev'
    location                   = $location
    administratorLogin         = 'sqladmin'
    administratorLoginPassword = $securePassword
    appName                    = 'psconfeu2023'
    tags                       = @{'for'='psconfeu2023'}
}
$deployment = New-AzResourceGroupDeployment @splat
