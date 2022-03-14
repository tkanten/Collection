# Basic info
$dump_file = "infodump.txt"
echo "Made by Trevor Kanten" > $dump_file

Function SectionHeader {
    Param ($SectionName)
    echo "==============================================================" >> $dump_file
    echo "SECTION $SectionName" >> $dump_file
    echo "==============================================================" >> $dump_file

}

Function SubDivider {
    echo "++=++=++=++=++=++=++=++=++=++=++=++=++=++=++=++=++=++=++=++=++" >> $dump_file
}

Function Get-BasicInfo {
    SectionHeader "Basic Info"

    echo "System Info:" > $dump_file
    systeminfo | findstr /B /C:'OS NAME' /C:'OS Version' >> $dump_file

    SubDivider

    echo "Hostname:" >> $dump_file
    hostname >> $dump_file

    SubDivider

    echo "Current User:" >> $dump_file
    echo $env:UserName >> $dump_file

    SubDivider

    echo "Path:" >> $dump_file
    echo $env:path >> $dump_file

    SubDivider

    echo "Users:" >> $dump_file
    net users >> $dump_file

    SubDivider

    echo "Administrators:" >> $dump_file
    net localgroup Administrators >> $dump_file

    SubDivider

    echo "RDP Users:" >> $dump_file
    net localgroup "Remote Desktop Users" >> $dump_file

    SubDivider
}

Function Get-NetworkInfo {
    echo "Network Information:" > $dump_file
    ipconfig /all >> $dump_file

    SubDivider

    echo "Routes:" >> $dump_file
    route print >> $dump_file
    
    SubDivider

    echo "Local Network:" >> $dump_file
    arp -A >> $dump_file

    SubDivider

    netstat -ano >> $dump_file

    SubDivider

}

Function Get-FirewallEnum {

    echo "Firewall State:"
    netsh firewall show state >> $dump_file

    SubDivider $dump_file

    echo "Firewall Config:" >> $dump_file
    netsh firewall show config
}



Get-BasicInfo
#Get-NetworkInfo
#Get-FirewallEnum



