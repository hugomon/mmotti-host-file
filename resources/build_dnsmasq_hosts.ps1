# Get the script's parent directory
$parent_dir   = (Get-Item $PSScriptRoot).Parent.FullName
# Check whether we are running from the git repo
$isGitRepo    = Get-ChildItem -Attributes "Hidden" -Filter ".git" $parent_dir

# Conditional output location
if($isGitRepo)
{
    $out_file     = "$parent_dir\wildcard_hosts_dnsmasq.conf"
}
else
{
    $out_file     = "$PSScriptRoot\wildcard_hosts_dnsmasq.conf"
}

# Get the wildcard host input file
$wcard_hosts = (Invoke-WebRequest -Uri "https://raw.githubusercontent.com/mmotti/mmotti-host-file/master/wildcard_standard_hosts.txt").Content -split "\n" -match "(\*\.)" -replace "\*\."

# Create empty array
$dnsmasq_arr = @()

# For each wildcard
foreach($wcard in $wcard_hosts)
{
    # Convert to dnsmasq format
    $wcard = "address=/$wcard/0.0.0.0"
    
    # Add to array
    $dnsmasq_arr += $wcard
}

# Join on a new line
$dnsmasq_arr = $dnsmasq_arr -join "`n"

# Output to screen
Write-Output $dnsmasq_arr

# Output to file
[System.IO.File]::WriteAllText($out_file,$dnsmasq_arr)