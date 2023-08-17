###############################################################################
#   ListConnectedVMs.ps1
#       by amrichards
#
#   List any user connected VMs given a list of horizon view servers.
#
#   Inputs:
#       $username - sAMAccountName of user
#       $servers - list of horizon view servers
#       $domain - on prem domain name
#       $authuser - username for authenticated account
#       $authpass - password for authenticated account
#
#   Outputs:
#       $message - Written to host for each connected VM
###############################################################################

Import-Module VMware.VimAutomation.HorizonView -ErrorAction SilentlyContinue -WarningAction SilentlyContinue  #Silence error on Get-VM load and any warnings
Import-Module VMware.Hv.Helper -ErrorAction SilentlyContinue -WarningAction SilentlyContinue #Silence error on Get-VM load and any warnings

# Reset All VMs given a usernamew
$username = "sAMAccountName"
$servers = "server1", "server2"
$domain = "example.com"
$authuser = "username"
$authpass = "password" # Consider using saved credential from example SecureString-Files.ps1
foreach ($server in $servers) {
    # Connect to Horizon View Server
    Connect-HVServer -Server $server -User $authuser -Password $authpass -Domain $domain
    # Create a new Query on HV and apply filter
    $HorizonServerServices = $global:DefaultHVServers[0].ExtensionData
    $HorizonQuery = New-Object VMware.Hv.QueryDefinition
    $HorizonQuery.QueryEntityType = 'SessionLocalSummaryView'
    $QueryFilterEquals = New-Object VMware.Hv.QueryFilterEquals
    $QueryFilterEquals.MemberName = 'namesData.userName'
    $QueryFilterEquals.value = "$domain\$username"
    $HorizonQuery.Filter = $QueryFilterEquals
    $HorizonQueryService = New-Object VMware.Hv.QueryServiceService
    # Grab Results from Query
    $SearchResult = $HorizonQueryService.QueryService_Query($HorizonServerServices, $HorizonQuery)

    # Cycle through VMs to run reset VM
    foreach ($connectedVM in $SearchResult.Results.Namesdata.MachineOrRDSServerName) {
        $message = $username + " is connected to: " + $connectedVM
        Write-Host $message
    }

    Disconnect-HVServer -Confirm:$false
}