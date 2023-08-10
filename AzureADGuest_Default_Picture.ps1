$Guests = Get-AzureADUser -Filter "Usertype eq 'Guest'" -All $True
ForEach ($Guest in $Guests) {
   # Does a photo exist?
   $PhotoExists = $Null
   Try {$PhotoExists = Get-AzureADUserThumbnailPhoto -ObjectId $Guest[0].ObjectId }
       Catch {  # Nope - so update account with default picture
       Write-Host "Photo does not exist for" $Guest.DisplayName "- updating with default guest logo"
       Set-AzureADUserThumbnailPhoto -ObjectId $Guest.ObjectId -FilePath C:\Temp\DefaultGuestPicture.jpg  }}