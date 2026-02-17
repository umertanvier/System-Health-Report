# System Health Check Report Script
# Author: Umer
# Date: 2026-02-16

# Initialize report array
$Report = @()
$Report += "System Health Report - $(Get-Date)"
$Report += "----------------------------"

# CPU Usage
$CPU = Get-WmiObject Win32_Processor | Measure-Object -Property LoadPercentage -Average | Select -ExpandProperty Average
$Report += "CPU Usage: $CPU%"

# Total RAM
$RAM = [math]::Round((Get-WmiObject Win32_ComputerSystem).TotalPhysicalMemory / 1GB, 2)
$Report += "Total RAM: $RAM GB"

# Disk Space
$Report += "Free Disk Space:"
Get-PSDrive -PSProvider FileSystem | ForEach-Object {
    $FreeGB = [math]::Round($_.Free / 1GB, 2)
    $TotalGB = [math]::Round($_.Used / 1GB + $_.Free / 1GB, 2)
    $Report += "$($_.Name): $FreeGB GB free of $TotalGB GB"
}

# Save report to Documents folder
$ReportPath = "C:\Users\$env:USERNAME\Documents\SystemHealthReport.txt"
$Report | Out-File $ReportPath

# Output success message
Write-Output "Report generated at $ReportPath"
