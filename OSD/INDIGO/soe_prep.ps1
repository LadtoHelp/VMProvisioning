#Install the System Language components

winget install 9nt52vq39bvn -s msstore --accept-source-agreements -h --accept-package-agreements

Install-Language en-AU -CopyToSettings
Set-SystemPreferredUILanguage en-AU
Set-WinSystemLocale -SystemLocale en-AU

Set-WinUserLanguageList -LanguageList en-AU
Set-WinUILanguageOverride -Language en-AU
Set-WinHomeLocation -GeoId 12
Set-Culture en-AU

Copy-UserInternationalSettingsToSystem -WelcomeScreen $True -NewUser $True



