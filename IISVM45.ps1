

Configuration IISInstall
{
Node TestVM45
{
WindowsFeature IIS
{
Ensure = "Present"
Name = "Web-Server"
}
WindowsFeature ASP
{
Ensure = "Present"
Name = "Web-Asp-Net45"
}
}
}
IISInstall


#Publish-AzureVMDscConfiguration -ConfigurationPath "C:\Users\acampos\Documents\FY16\Scripts PWS\IISVM45.ps1"
