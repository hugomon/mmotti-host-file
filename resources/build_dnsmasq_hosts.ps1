# Define output file
$out_file = "$PSScriptRoot\wildcard_hosts_dnsmasq.conf"

# Get the wildcard host input file
$wcard_hosts = (Get-Content "$PSScriptRoot\wildcard_hosts.txt") -match "(\*\.)"

# Remove *.
$wcard_hosts = $wcard_hosts -replace "\*\."

# Create empty array
$dnsmasq_arr = @()

# For each wildcard
foreach($wcard in $wcard_hosts)
{
    # Convert to dnsmasq format
    $wcard = "address=/$wcard/192.168.1.200"
    
    # Add to array
    $dnsmasq_arr += $wcard
}

# Join on a new line
$dnsmasq_arr = $dnsmasq_arr -join "`n"

# Output to file
[System.IO.File]::WriteAllText($out_file,$dnsmasq_arr)