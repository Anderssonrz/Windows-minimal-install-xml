Write-Host "Debloat agressivo iniciado..."

# Remover apps provisionados
Get-AppxProvisionedPackage -Online | Where-Object {$_.DisplayName -notmatch "Store|Calculator"} | Remove-AppxProvisionedPackage -Online

# Remover apps atuais
Get-AppxPackage -AllUsers | Where-Object {$_.Name -notmatch "Store|Calculator"} | Remove-AppxPackage -AllUsers

# Desativar serviços pesados
$services = @(
"DiagTrack",
"WSearch",
"SysMain",
"MapsBroker",
"Fax",
"RetailDemo"
)

foreach ($svc in $services) {
    Stop-Service -Name $svc -Force -ErrorAction SilentlyContinue
    Set-Service -Name $svc -StartupType Disabled
}

# Desativar consumer features
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v DisableConsumerFeatures /t REG_DWORD /d 1 /f

# Desativar telemetria
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f

# Ultimate Performance
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61

# Desativar hibernação
powercfg -h off

Write-Host "Debloat concluído!"
