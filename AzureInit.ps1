Write-Output "------ Change Execution Policy ------"
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Bypass -Force  # ****** Requires Admin ********

Write-Output "------ Change Power Settings ------"
Write-Output "[*] Changing sleep settings"
Powercfg /Change monitor-timeout-ac 0
Powercfg /Change monitor-timeout-dc 0
Powercfg /Change standby-timeout-ac 0
Powercfg /Change standby-timeout-dc 0

Write-Output "------ MS Package installation ------"
# Install MS tools
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -Confirm:$false
Install-Module MSOnline -Confirm:$false -Force
iwr -Uri https://azurecliprod.blob.core.windows.net/msi/azure-cli-2.29.2.msi -OutFile .\AzureCLI.msi; Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'; rm .\AzureCLI.msi
Enable-WindowsOptionalFeature -Online -FeatureName "NetFx3" -NoRestart -LogLevel Errors
Install-Module -Name Az -Repository PSGallery -Force -AllowClobber
Install-Module AzureADPreview -Scope CurrentUser
Install-Module AADInternals -Scope CurrentUser
az extension add --upgrade -n automation

$cred1 = Get-credential

Write-Output "------ 3rd Party Tools  Download ------"
# Download 3rd party tools
wget https://github.com/hausec/PowerZure/archive/refs/heads/master.zip -OutFile $HOME\Powerzure.zip
wget https://github.com/NetSPI/MicroBurst/archive/refs/heads/master.zip -OutFile $HOME\MicroBurst.zip
wget https://github.com/dafthack/MailSniper/archive/refs/heads/master.zip -OutFile $HOME\mailsniper.zip

Write-Output "------ 3rd Party Tools  Extraction ------"
Expand-Archive  $HOME\Powerzure.zip -DestinationPath $HOME
Expand-Archive  $HOME\microburst.zip -DestinationPath $HOME
Expand-Archive  $HOME\mailsniper.zip -DestinationPath $HOME

Write-Output "------ Loading Tools  ------"
# Import all the modules
$MBmodules = Get-ChildItem -Recurse -File $HOME\MicroBurst-master\ -Filter "*.ps1" -Exclude "DeployDSCAgent.ps1","TokenFunctionApp.ps1","AutomationRunbook-OwnerPersist.ps1","Invoke-AzureRmVMBulkCMD.ps1","ExportManagedIdentityToken.ps1","DSCHello.ps1"
foreach ($MBmodule in $MBmodules){
	$MBmodule.fullname
	ipmo $MBmodule.fullname
}
ipmo $HOME\PowerZure-master\powerzure.psd1
ipmo $HOME\MailSniper-master\MailSniper.ps1
import-module AADInternals
ipmo azure
Import-Module Az
Import-Module MSOnline
az extension add --upgrade -n automation
# Connect to all of the services
Connect-AzAccount -Credential $cred1
Connect-MsolService -Credential $cred1
Connect-AzureAD -Credential $cred1

Write-Output "------ Assigning Variables ------"
# Create Vars for everything
$accessToken = Get-azaccesstoken
$tenant = $accesstoken.TenantId
$token = $accesstoken.token
$userid = $accesstoken.userId
$context = Get-AzContext
$context.name
$context.account
$subscription = (Get-AzSubscription).Id
$subscriptionName = (Get-AzSubscription).Name

az login --tenant $tenant -u $ryanAdmCred.UserName -p $ryanAdmCred.Password
az account set --subscription $subscription
az account show


Write-Output "-------------------------Install Complete-----------------------"
