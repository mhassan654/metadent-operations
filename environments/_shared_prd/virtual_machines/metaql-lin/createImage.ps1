$imageName = 'metaql-linux-20240607'
$rgSource = "metaql-prd-rg"
$vm = "metaql-prd-01"

$resourceType = "Microsoft.Compute/images"
$rgTarget = "Infrastructure"

az vm deallocate --resource-group $rgSource --name $vm
az vm generalize --resource-group $rgSource --name $vm
az image create  --resource-group $rgSource --name $imageName --source $vm --hyper-v-generation V1

$imageResource=$(az resource show -g $rgSource -n $imageName --resource-type $resourceType --query id --output tsv)
az resource move --destination-group $rgTarget --ids $imageResource

