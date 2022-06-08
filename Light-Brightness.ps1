param (
    [Parameter()][string]$EntityID,
    [Parameter(Mandatory = $true)]
    [ValidateSet('Inc','Dec')][string]$IncDec
)

function Increase-Brightness ($scale, $brightness) {
    if (($brightness + $scale) -gt 255) {
        Set-HAEntityBrightness -EntityID $EntityID -Brightness 255
    } else {
        Set-HAEntityBrightness -EntityID $EntityID -Brightness ($brightness + $scale)
    }
}

function Decrease-Brightness ($scale, $brightness) {
    if (($brightness - $scale) -lt 0) {
        Set-HAEntityBrightness -EntityID $EntityID -Brightness 0
    } else {
        Set-HAEntityBrightness -EntityID $EntityID -Brightness ($brightness - $scale)
    }
}

try {
    Import-Module ".\HomeAssistant\HomeAssistant" -Force

    $ip = ""
    $token = ""

    Set-HASession -IPAddress $ip -APIToken $token

    [int]$scale = 10
    $state = Get-HAEntityState -EntityID $EntityID | select -ExpandProperty attributes
    [int]$brightness = $state.brightness

    switch($IncDec) {
        Inc {Increase-Brightness $scale $brightness}
        Dec {Decrease-Brightness $scale $brightness}
    }
} catch{
    Write-Error $_
}