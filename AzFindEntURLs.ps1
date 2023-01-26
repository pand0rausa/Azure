# This script will import the AzureAD module, connect to Azure AD, and then retrieve all enterprise applications by using the Get-AzureADServicePrincipal command with the -All parameter set to $true. 
# Then, it will loop through each application, get the app's reply URLs, and print the app's display name and the URL.

# Import the AzureAD module
Import-Module AzureAD

# Connect to Azure AD
Connect-AzureAD

# Get all enterprise applications
$apps = Get-AzureADServicePrincipal -All $true

# Loop through each application
foreach ($app in $apps) {
    # Get the app's reply URLs
    $replyUrls = $app.ReplyUrls

    # Loop through each reply URL
    foreach ($url in $replyUrls) {
        # Print the app's display name and the URL
        Write-Output "Application: $($app.DisplayName)"
        Write-Output "URL: $url"
    }
}
