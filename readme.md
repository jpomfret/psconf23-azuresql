# PSConfEU 2023 - Building Azure Infrastructure with PowerShell Azure Functions called from inside a Azure SQL DB

## Description

Azure SQL DB now has the ability to call REST endpoints from within the database, this means you can integrate your database code with data from the outside world - anything that can be retrieved from a REST endpoint.

It also means you can call Azure PowerShell Functions to do work for you based on data within your database.

In this session we'll build a database that not only keeps track of our Azure infrastructure - but actually builds it out for us. Imagine if adding a row to a table could kick off a process to actually deploy those Azure resources.

### notes

Added permissions to managed identity for the function

- subscription reader
- psconfeu rg contributor

### Other examples

- Send payload to SignalR enabled website
![image](https://github.com/jpomfret/psconf23-azuresql/assets/981370/69b7a695-c462-446b-8bd9-2edff046ea79)

### Flow

Into to tech

- explain the whole architecture - this is a session to give you ideas, and suggestions for what you want to learn
  - we could do a whole day on diving into all these technologies and then how they work together
  - if you're not an expert in all these don't worry - we'll explain enough to understand what and why, but it'll be homework to understand all of the hows

- maybe draw a diagram of the architecture and then talk through it
  - vscode devcontainer - every project needs a dev container
    - allows us to develop functions locally
  - Azure Functions
  - Github Repo \ source control
  - Github Actions
  - Azure - Resource group, storage account, azure sql server

Show making a change to the function

- allow option to pass in location or sku
- test locally
- commit to repo
- push code

Log messages - write-host in function --> log analytics

### authentication

https://github.com/Azure-Samples/azure-sql-db-invoke-external-rest-endpoints/blob/main/azure-functions.ipynb

- enable managed identity for Azure SQL - https://github.com/Azure-Samples/azure-sql-db-invoke-external-rest-endpoints/blob/105979caf78cb43fa73f2bcb83edba4e5f356e57//azure-sql-enable-msi.ipynb
- add app authentication to your web app running on Azure App Service  https://learn.microsoft.com/en-gb/azure/app-service/scenario-secure-app-authentication-app-service
- Create a DATABASE SCOPED CREDENTIAL
  - REFERENCE permissions for anyone who needs to use it
- add credential param to the call of sp_invoke_external_rest_endpoint

### Links

https://devblogs.microsoft.com/azure-sql/azure-sql-database-external-rest-endpoints-integration-public-preview/
https://learn.microsoft.com/en-us/sql/relational-databases/system-stored-procedures/sp-invoke-external-rest-endpoint-transact-sql?view=azuresqldb-current&tabs=request-headers7

https://learn.microsoft.com/en-us/samples/azure-samples/functions-storage-managed-identity/using-managed-identity-between-azure-functions-and-azure-storage/
https://github.com/Azure-Samples/azure-sql-db-invoke-external-rest-endpoints/tree/main

