#Requires -RunAsAdministrator
$banner = @"


                        ::::::::::::::::::::
                      ::::::::::::::::::::::::
                    ::::::::::::::::::::::::::::
                  :::::::::::::::::::::::::::::::
                ::::::::::::::::::::::::::::::::::
               ::::::::::::::::::::::::::::::::::::
              ::::::::::::::::        :::::::::::::::
              ::::::::::::::::        ::::::::::::::::
              ::::::::::::::::        ::::::::::::::::
              ::::::::::::::::        ::::::::::::::::
              ::::::::::::::::        ::::::::::::::::
              ::::::::::::::::        ::::::::::::::::
              ::::::::::::::::        ::::::::::::::::
              ::::::::::::::::        ::::::::::::::::
              ::::::::::::::::        :::::::::::::::
              ::::::::::::::::        :::::::::::::::
                ::::::::::::::        ::::::::::::::
                                      ::::::::::::
                    :::::::::::::::::::::::::::::
                  ::::::::::::::::::::::::::::::::
                 ::::::::::::::::::::::::::::::::::
                ::::::::::::::::::::::::::::::::::::
               ::::::::::::::::::::::::::::::::::::::
              ::::::::::::::::::::::::::::::::::::::::

"@
Clear-Host
Write-Host $banner -ForegroundColor Cyan
Write-Host "                          BAM by Guardian" -ForegroundColor Cyan
Write-Host ""
Write-Host "                             " -NoNewline
Write-Host "IMPORTANT" -BackgroundColor Red -ForegroundColor White
Write-Host "                     DO NOT CLOSE THIS WINDOW" -ForegroundColor Red
Write-Host ""
Write-Host "                This window will close automatically"
Write-Host "             when you close the main application window."
Write-Host ""
Write-Host ""
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
  Write-Host "Please run this script as an administrator."
  Pause
  Exit
}
$path = $env:LOCALAPPDATA + "\BAM by Guardian"
Remove-Item -Path $path -Recurse -Force -ErrorAction Ignore
New-Item -ItemType Directory -Path $path -Force | Out-Null
$downloadUrl = "https://github.com/PiggyPlex/bam-tool/releases/download/v1.0.0/BAM.by.Guardian_1.0.0_x86-setup.exe"
$installerPath = [System.IO.Path]::Combine($path, "installer.exe")
Invoke-WebRequest -Uri $downloadUrl -OutFile $installerPath
Start-Process -FilePath $installerPath -ArgumentList "/S","/D","`"$path`""
$isInstalled = $false
$exePath = [System.IO.Path]::Combine($path, "BAM by Guardian.exe")
while (-not $isInstalled) {
  $isInstalled = Test-Path -Path $exePath
  if (-not $isInstalled) {
    Start-Sleep -Milliseconds 250
  }
}
Start-Sleep -Milliseconds 500
Start-Process -FilePath $exePath -Wait
Start-Sleep -Milliseconds 500
$uninstallerPath = [System.IO.Path]::Combine($path, "uninstall.exe")
Start-Process -FilePath $uninstallerPath -ArgumentList "/S","/D","`"$path`""
Remove-Item -Path $path -Recurse -Force -ErrorAction Ignore
Exit
