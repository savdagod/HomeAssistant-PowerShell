function Set-HASession {
    param (
        [Parameter(mandatory=$true)][string]$IPAddress,         
        [Parameter(mandatory=$true)][string]$APIToken
    )
    $global:ip = $IPAddress
    $global:header = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $header.Add("authorization", "Bearer $APIToken")
}

function Set-HAEntityState {
    param (
        [Parameter(mandatory=$true)]
        [string]$EntityID,

        [Parameter(mandatory=$true)]
        [ValidateSet('on','off')]
        [string]$State
    )
    [string[]]$EntityID = $EntityID.Split(".")
    $EntityType = $EntityID[0]
    $EntityName = $EntityID[1]

    $url="$ip/api/services/$EntityType/turn_$State"
    $JSON = @{entity_id = "$EntityType.$EntityName"}
    $JSON = $JSON | ConvertTo-Json

    Invoke-RestMethod -Uri $url -Headers $header -Method post -Body $JSON
}

function Set-HAEntityBrightness {
    param (
        [Parameter(mandatory=$true)]
        [string]$EntityID,

        [Parameter(mandatory=$true)]
        [int]$Brightness
    )
    [string[]]$EntityID = $EntityID.Split(".")
    $EntityType = $EntityID[0]
    $EntityName = $EntityID[1]

    $url="$ip/api/services/$EntityType/turn_on"
    $JSON = @{entity_id = "$EntityType.$EntityName"
    brightness = "$Brightness"}
    $JSON = $JSON | ConvertTo-Json

    Invoke-RestMethod -Uri $url -Headers $header -Method post -Body $JSON
}

function Get-HAEntityState {
    param (
        [Parameter(mandatory=$true)]
        [string]$EntityID
    )
    [string[]]$EntityID = $EntityID.Split(".")
    $EntityType = $EntityID[0]
    $EntityName = $EntityID[1]
    
    $url="$ip/api/states/$EntityType.$EntityName"

    $response = Invoke-RestMethod -Uri $url -Headers $header -Method Get
    Return $response
}

