# Basic info

Function Divider {
    Param ($file)
    echo "++=++=++=++=++=++=++=++=++=++=++=++=++=++=++=++=++=++=++=++=++" >> $file
}

Function Get-BasicInfo {
    $basic_info = "basic_info.txt"
    echo "System Info:" > $basic_info
    systeminfo | findstr /B /C:'OS NAME' /C:'OS Version' >> $basic_info

    Divider $basic_info

    echo "Hostname:" >> $basic_info
    hostname >> $basic_info

    Divider $basic_info

    echo "Current User:" >> $basic_info
    echo $env:UserName >> $basic_info

    Divider $basic_info

    echo "Path:" >> $basic_info
    echo $env:path >> $basic_info

    Divider $basic_info

    echo "Users:" >> $basic_info
    net users >> $basic_info

    Divider $basic_info

    echo "Administrators:" >> $basic_info
    net localgroup Administrators >> $basic_info

    Divider $basic_info

    echo "RDP Users:" >> $basic_info
    net localgroup "Remote Desktop Users" >> $basic_info

    Divider $basic_info
}

Function Get-NetworkInfo{
    $network_info = "network_information.txt"
    
    echo "Network Information:" > $network_info
    ipconfig /all >> $network_info

    Divider $network_info

    echo "Routes:" >> $network_info
    route print >> $network_info
    
    Divider $network_info

    echo "Local Network:" >> $network_info
    arp -A >> $network_info

    Divider $network_info

    netstat -ano

    Divider $network_info

}

Function Get-FirewallEnum{
    $firewall = "firewall_info.txt"

    echo "Firewall State:"
    netsh firewall show state >> $firewall

    Divider $firewall

    echo "Firewall Config:" >> $firewall
    netsh firewall show config
}

Get-BasicInfo
Get-NetworkInfo
Get-FirewallEnum



