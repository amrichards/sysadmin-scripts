###############################################################################
#   PowerCLISetup.ps1
#       by amrichards
#
#   Set up PowerCLI for your environment
###############################################################################

# Installing VMware PowerCLI
Find-Module -Name VMware.PowerCLI
Install-Module -Name VMware.PowerCLI -Scope CurrentUser
Get-Command -Module *VMWare*

#Set the participation to false and ignore invalid certificates for all users
Set-PowerCLIConfiguration -Scope AllUsers -ParticipateInCeip $false -InvalidCertificateAction Ignore

#Import the Horizon View module
Import-Module -Name VMware.VimAutomation.HorizonView 
#Import extra module that allows 
Import-Module -Name VMware.Hv.Helper