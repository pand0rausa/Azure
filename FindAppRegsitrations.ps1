# This script will connect to Azure AD and then retrieve all App registrations by using the Get-AzureADApplication command. 
#Then, it will loop through each App registration, get the App registration's redirect URIs, and print the App registration's display name and the URI.

# Connect to Azure AD
Connect-AzureAD

# Get all App Registrations
$appRegistrations = Get-AzureADApplication

# Loop through each App Registration
foreach ($appRegistration in $appRegistrations) {
    # Get the App Registration's redirect URIs
    $redirectURIs = $appRegistration.ReplyUrls
    
    # Loop through each redirect URI
    foreach ($uri in $redirectURIs) {
        # Print the App Registration's display name and the URI
        Write-Output "App Registration: $($appRegistration.DisplayName)"
        Write-Output "URI: $uri"
    }
}
