. .\ResolutionMatcher-Functions.ps1
Start-Transcript .\log.txt
$lastStreamed = [System.DateTime]::MinValue
$hostResolution = Get-HostResolution
$onStreamEventTriggered = $false
while ($true) {
    $delaySettings = if (IsSunshineUser) { [pscustomobject]@{StartDelay = 1; EndDelay = 1; } } Else { [pscustomobject]@{StartDelay = 8; EndDelay = 0 } }
    if (UserIsStreaming) {
        $lastStreamed = Get-Date
        if (!$onStreamEventTriggered) {
            # Capture host resolution again, in case it changed recently.
            $hostResolution = Get-HostResolution
            Start-Sleep -Seconds $delaySettings.StartDelay
            OnStreamStart
            $onStreamEventTriggered = $true
        }

    }
    elseif ($onStreamEventTriggered -and ((Get-Date) - $lastStreamed).TotalSeconds -gt $delaySettings.EndDelay) {
        OnStreamEnd $hostResolution
        $onStreamEventTriggered = $false
        
    }
    Start-Sleep -Seconds 1
}

Stop-Transcript