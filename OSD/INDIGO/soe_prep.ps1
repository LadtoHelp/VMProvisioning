$AppName = "SOE Prep Tool"
$LogPath = "C:\windows\ccmsetup\logs"
$LogFileName = Join-Path $LogPath "$($AppName + ".log")"
if (!(Test-Path $LogPath -ErrorAction SilentlyContinue)) {
    mkdir $LogPath -Force
}

Start-Transcript -Path "$($LogFileName)"

#Install the System Language components
"`n`rInstalling Language Pack using WinGet" 

try {
    winget install 9nt52vq39bvn -s msstore --accept-source-agreements -h --accept-package-agreements
}
catch {
    Write-Error "Error installing Language Pack: $_"
    Write-Error "Error Code: $($_.Exception.HResult)"
}



Install-Language en-AU -CopyToSettings -Verbose
Set-SystemPreferredUILanguage en-AU -PassThru -Verbose
Set-WinSystemLocale -SystemLocale en-AU -Verbose

Set-WinUserLanguageList -LanguageList en-AU -Verbose
Set-WinUILanguageOverride -Language en-AU -Verbose
Set-WinHomeLocation -GeoId 12 -Verbose
Set-Culture en-AU -Verbose

Copy-UserInternationalSettingsToSystem -WelcomeScreen $True -NewUser $True


#Sync Intune
Get-ScheduledTask | where {$_.TaskName -eq 'PushLaunch'} | Start-ScheduledTask -Verbose


$interval = 20
$run = $true
$counter = 0
$serviceName = "RDAgentBootLoader"
do {
    Start-Sleep -Seconds $interval
    $service = Get-Service -Name $serviceName -ErrorAction SilentlyContinue
    if ($null -ne $service -and $service.Status -ne [System.ServiceProcess.ServiceControllerStatus](4)) {
        Write-Host "Starting service: $serviceName"
        Start-Service -Name $serviceName -ErrorAction SilentlyContinue
    }
    $counter++
    if ($counter -gt 10) { $interval = 90 }
    if ($counter -gt 20) { $run = $false }
} while ($run)