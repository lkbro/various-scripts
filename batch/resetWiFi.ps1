# Define the adapter name
$adapterName = "WiFi"

# Attempt to disable and then re-enable the specified network adapter
try {
    $adapter = Get-NetAdapter -Name $adapterName -ErrorAction Stop
    Disable-NetAdapter -Name $adapter.Name -Confirm:$false
    Write-Host "Adapter $($adapter.Name) disabled. Waiting for 5 seconds..."
    Start-Sleep -Seconds 5
    Enable-NetAdapter -Name $adapter.Name
    Write-Host "Adapter $($adapter.Name) enabled."
} catch {
    Write-Host "Error: Could not find an adapter with the name '$adapterName'. Please ensure you have entered the correct adapter name."
}
