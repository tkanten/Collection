# Basic info
$dump_file = "infodump.txt"

Function Divider {
    echo "++=++=++=++=++=++=++=++=++=++=++=++=++=++=++=++=++=++=++=++=++" >> $dump_file
}

Function Get-BasicInfo {
    echo "System Info:" > $dump_file
    systeminfo | findstr /B /C:'OS NAME' /C:'OS Version' >> $dump_file

    Divider

    echo "Hostname:" >> $dump_file
    hostname >> $dump_file

    Divider

    echo "Current User:" >> $dump_file
    echo $env:UserName >> $dump_file

    Divider

    echo "Path:" >> $dump_file
    echo $env:path >> $dump_file

    Divider

    echo "Users:" >> $dump_file
    net users >> $dump_file

    Divider

    echo "Administrators:" >> $dump_file
    net localgroup Administrators >> $dump_file

    Divider

    echo "RDP Users:" >> $dump_file
    net localgroup "Remote Desktop Users" >> $dump_file

    Divider
}

Function Get-NetworkInfo{
    echo "Network Information:" > $dump_file
    ipconfig /all >> $dump_file

    Divider

    echo "Routes:" >> $dump_file
    route print >> $dump_file
    
    Divider

    echo "Local Network:" >> $dump_file
    arp -A >> $dump_file

    Divider

    netstat -ano >> $dump_file

    Divider

}

Function Get-FirewallEnum{

    echo "Firewall State:"
    netsh dump_file show state >> $dump_file

    Divider $dump_file

    echo "Firewall Config:" >> $dump_file
    netsh dump_file show config
}

Get-BasicInfo
Get-NetworkInfo
Get-FirewallEnum



