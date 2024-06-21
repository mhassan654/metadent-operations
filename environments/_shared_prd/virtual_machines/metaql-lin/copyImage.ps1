$resourceGroupName = "Infrastructure"
$imageName = "metaql-linux-20240607"
$location = "westeurope"
$targetSubscriptionId = "9f3afebc-aa2c-42fa-97a3-7c9435c6721c"
az image copy --source-resource-group $resourceGroupName `
                --source-object-name $imageName `
                --target-location $location `
                --target-resource-group $resourceGroupName `
                --target-subscription $targetSubscriptionId --cleanup