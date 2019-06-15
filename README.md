## ravms - **r**anolfi's **a**ndroid **v**irtual **m**achine **s**hare

Share files between your PC and an Android-x86 virtual machine.

**Note:** Assumes a GNU/Linux operating system. Mostly portable, though I don't have the time to port it myself ATM.

### Requirements:

#### On the computer:
- Android Debug Bridge (adb) - https://developer.android.com/studio/command-line/adb  
  <sub>(part of [`android-tools`](https://www.archlinux.org/packages/community/x86_64/android-tools/) package in Arch Linux)</sub>

#### On the virtual machine:
- A terminal emulator <sub>(the official Android-x86 release already includes the one from https://play.google.com/store/apps/details?id=jackpal.androidterm if I'm not mistaken)</sub>
- Root access
- Network connectivity between guest and host (in [virt-manager](https://virt-manager.org/) the network interface must be in `bridged` mode)

### How to use:

### Sending files from host to VM

  1. In terminal emulator (in the VM), run `ip a` and note the IP address of the virtual network adapter. It's usually the last one in the list. It's named `eth0` on my VM.  
  It ***must*** be in the same subnet as the host (i.e. host IP is `192.168.0.2` and Android-x86 VM IP is `192.168.0.3`).

  2. Change the IP address in the `Adb Push.sh` script @line 1 to the one you just noted.

  3. Put any files you wish to send to the Android-x86 VM in the `Transfers` folder. Feel free to delete the `.gitkeep` file while at it.

  4. Run the `Adb Push.sh` script.

  5. In the Android VM, browse to /sdcard/Transfers and find your newly pushed files.

### Pulling files from VM to host

  1. (Follow step 1 from instructions above)

  2. Change the IP address in the `Adb Pull.sh` script @line 1 to the one from step 1.

  3. Put any files you wish to send back to the host in a directory named `out` under `/sdcard/Transfers/` (you'll probably need to create it).

  4. Run the `Adb Pull.sh` script in the host.

  5. Find your newly pulled files in the `Transfers/out` directory.

### Remarks

1. If you see:

    > unable to connect to 192.168.0.8:5555: No route to host  
    > adb: error: failed to get feature set: no devices/emulators found

    then there is no connectivity to the VM.
    
    If you indeed are using QEMU-KVM (possibly with `virt-manager`), I have the [`rmacvlan`](https://gitlab.com/ranolfi/rmacvlan) script to aid in getting virtual machines to talk to the host via network.

2. The first time you run either script, you should expect to see:

    > * daemon not running; starting now at tcp:5037  
    > * daemon started successfully

    After that, all further runs will show:

    > already connected to \[ip:port\]

    This is normal and expected. If, for any reason, the scripts stops working after rebooting the VM, you may get around that by running `adb kill-server` in the host.

3. Two additional scripts are provided for convenience: `rip` and `rrscan`. Those are intended to be copied to and used from the Android-x86 virtual machine. I recommend placing them under `/system/sbin` so that they can be called anytime from the terminal emulator right after executing `su`. Make sure they are executable, i.e. `chmod u+x rip` | `chmod u+x rscan`.

  - `rip` is used to add a predefined IP address to the VM's network interface so that you won't have to edit your `Adb Pull.sh` and `Adb Push.sh` everytime. It must be run *before* running either script in the host.

  - `rrscan` is useful to get your recently pushed media to be recognized by media applications (e.g. photos will appear in the gallery without having to reboot.) This script should be run *after* pushing files.  
  <sub>(Note: it is probably possible to run `adb shell "su -c 'am broadcast -a android.intent.action.MEDIA_MOUNTED -d file:///mnt/sdcard'"` right after `adb push` from the `Adb Push.sh` script, and this eliminates the need for the `rrscan` script. But I haven't tested.)</sub>

### Support:

Please open an issue and I'll try my best to help you.
