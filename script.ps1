# Basic info

$divider = "--------------------------------------------------------------------"
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
echo net users >> $basic_info

