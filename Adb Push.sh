adb connect 192.168.0.8
sleep 1
adb push /home/ranolfi/Desktop/Transfers/* /sdcard/Transfers
echo ""
echo "Remember to run 'rescan in Android Terminal as root."
echo "The 'rescan' script is placed under /system/sbin".
echo ""
read -n 1 -s -r -p "Press any key to continue."
