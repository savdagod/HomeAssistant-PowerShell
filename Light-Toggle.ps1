param (
    [Parameter()][string[]]$EntityIDs,
    [Parameter()][ValidateSet('','on','off')][string]$OnOff = ''       
)

try {
    Import-Module ".\HomeAssistant\HomeAssistant" -Force

    $ip = ""
    $token = ""

    Set-HASession -IPAddress $ip -APIToken $token

    foreach ($EntityID in $EntityIDs) {
        if ($OnOff -eq '') {
            $state = Get-HAEntityState -EntityID $EntityID | select -ExpandProperty state
            if ($state -eq 'on') {
                Set-HAEntityState -EntityID $EntityID -State 'off'
            } else {
                Set-HAEntityState -EntityID $EntityID -State 'on'
            }
        } else {
            Set-HAEntityState -EntityID $EntityID -State $OnOff
        }
    }
} catch{
    Write-Error $_
}