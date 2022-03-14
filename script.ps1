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
echo %username% >> $basic_info

echo $divider >> $basic_info


