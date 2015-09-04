$vm = New-AzureVMConfig -Name "TestVM45" -InstanceSize Small -ImageName $image  

$vm = Add-AzureProvisioningConfig -VM $vm -Windows -AdminUsername "sysadmin" -Password "Passw0rd!" 

$vm = Set-AzureVMDSCExtension -VM $vm -ConfigurationArchive "IISVM44.ps1.zip" -ConfigurationName "IISInstall"  


New-AzureVM -VM $vm -ServiceName "MVAZoneAutomate" -WaitForBoot -Verbose


 $family="Windows Server 2012 R2 Datacenter"
 $image=Get-AzureVMImage | where { $_.ImageFamily -eq $family } | sort PublishedDate -Descending | select -ExpandProperty ImageName -First 1




New-AzureVM -v