#Creamos un grupo de afinidad
 New-AzureAffinityGroup –Location “Central US” –Name “VMstorage”

**Location debe coincidir con la ubicacion donde creamos la Red VPN

# Creamos una cuenta de Storage y la seleccionamos por default
 New-AzureStorageAccount -StorageAccountName "vmmultinic1" -Label “VM-Multi-NICs” -AffinityGroup “VMstorage”

#Volvemos a seleccionar nuestra subscripcion ahora con nuestra cuenta de Storage como default
 Set-AzureSubscription –SubscriptionName “BizSpark” -CurrentStorageAccount vmmultinic1

# Seteamos Windows 2012 como la imagen de la VM que vamos a crear, esto lo pueden cambiar a gusto
$imagename = @( Get-AzureVMImage | where-object {$_.Label -like “Windows Server 2012 Datacenter″} ).ImageName
 $image = Get-AzureVMImage -ImageName $imagename

# Seteamos la configuracion de la VM
 $vm = New-AzureVMConfig -Name “VM2nics” -InstanceSize “Large” -Image $imagename

# Definimos las credenciales para la creacion de la VM
 Add-AzureProvisioningConfig –VM $vm -Windows -AdminUserName “sysadmin” -Password “Passw0rd!”

# Configuramos la NIC por default
 Set-AzureSubnet -SubnetNames “Subnet1″ -VM $vm
 Set-AzureStaticVNetIP -IPAddress “10.2.1.111” -VM $vm

# Ahora agremos las otras NICs dependiendo del tamaño de la VM
 Add-AzureNetworkInterfaceConfig -Name “Ethernet2″ -SubnetName “Subnet-2″ -StaticVNetIPAddress “10.2.2.222” -VM $vm

#Ahora creamos un cloud service vacio para hostear la VM en el.
 New-AzureService –ServiceName “MultipleNics” –AffinityGroup “VMstorage”

#Ahora por ultimo vamos a crear la VM, ServiceName es el nombre que le acabamos de dar al cloud service y VNetName es el nombre que le dimos a nuestra red VPN
 New-AzureVM -ServiceName “MultipleNics” –VNetName “MultipleNics” –VM $vm
