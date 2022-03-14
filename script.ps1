# Basic info

$divider = "--------------------------------------------------------------------"


Function Get-BasicInfo {
$basic_info = "basic_info.txt"
echo "System Info:" >> $basic_info
systeminfo | findstr /B /C:'OS NAME' /C:'OS Version' >> $basic_info

echo $divider >> $basic_info

echo "Hostname:" >> $basic_info
hostname >> $basic_info

echo $divider >> $basic_info

echo "Current User:" >> $basic_info
echo $env:UserName >> $basic_info

echo $divider >> $basic_info

echo "Path:" >> $basic_info
echo $env:path >> $basic_info

echo $divider >> $basic_info

echo "Users:" >> $basic_info
net users >> $basic_info

echo $divider >> $basic_info

echo "Administrators:" >> $basic_info
net localgroup Administrators >> $basic_info

echo $divider >> $basic_info

echo "RDP Users:" >> $basic_info
net localgroup "Remote Desktop Users" >> $basic_info
}

Get-BasicInfo
