###############################################################################
#   SecureString-Files.ps1
#       by amrichards
#
#   Converting passwords to encrypted string in txt file and reversing to 
#   secure string and plaintext. Each snippet is designed to be run
#   independently.
#
#   Inputs:
#       $key - set to key used in your environment
#       $passfile - set to filepath
#
#   Outputs:
#       $password - as plaintext string or securestring depending on script 
#           being run.
###############################################################################

#   Save Cred File      
#############################
[Byte[]] $key = (1..32)
$passfile = "X:\path\to\file\passfile.txt"
$Secure = Read-Host -AsSecureString
$Encrypted = ConvertFrom-SecureString -SecureString $Secure -Key $key
$Encrypted | Set-Content $passfile
#############################


#   Secure String Output
#############################
[Byte[]] $key = (1..32)
$passfile = "X:\path\to\file\passfile.txt"
$password = get-content $passfile | ConvertTo-SecureString -Key $key
#############################


#   Plaintext Output
#############################
[Byte[]] $key = (1..32)
$passfile = "X:\path\to\file\passfile.txt"
$passfile = Get-Content $passfile
$secfile = ConvertTo-SecureString $passfile -Key $key
$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secfile)
$password = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
[Runtime.InteropServices.Marshal]::ZeroFreeBSTR($BSTR)
#############################