# Basic info
$basic_info = "basic_info.txt"

echo "System Info:" >> basic_info.txt
systeminfo | findstr /B /C:'OS NAME' /C:'OS Version' >> $basic_info

