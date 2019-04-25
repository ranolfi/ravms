adb connect 192.168.0.8
sleep 1
adb push /home/ranolfi/Desktop/Transfers/* /sdcard/Transfers
echo ""
echo "Remember to run 'rrescan' in Android Terminal as root."
echo "The 'rrescan' script is placed under /system/sbin".
echo ""
read -n 1 -s -r -p "Press any key to continue."
