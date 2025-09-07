# MapZDrivePersistent.ps1
# Maps drive Z: to a Synology NAS share using CIFS/SMB
# The mapping will persist and reconnect on every boot

$NASPath = "\\192.168.1.100\SharedFolder"   # Replace with your NAS IP and share name
$Username = "NAS_Username"                  # Replace with your NAS username
$Password = "NAS_Password"                  # Replace with your NAS password

cmd.exe /c "net use Z: $NASPath /user:$Username $Password /persistent:yes"
