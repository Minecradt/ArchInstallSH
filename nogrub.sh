echo o > script.txt
echo n >> script.txt
echo p >> script.txt
echo 1 >> script.txt
echo -en '\n' >> script.txt
echo +1G >> script.txt
echo -en '\n' >> script.txt
echo n >> script.txt
echo p >> script.txt
echo 2 >> script.txt
echo -en '\n' >> script.txt
echo +4G >> script.txt
echo -en '\n' >> script.txt
echo n >> script.txt
echo p >> script.txt
echo 3 >> script.txt
echo -en '\n' >> script.txt
echo -en '\n' >> script.txt
echo -en '\n' >> script.txt
echo w >> script.txt
cat script.txt | fdisk /dev/sda
echo Created Partitions!
echo Formatting them.
mkfs.ext4 /dev/sda3
mkfs.fat -F 32 /dev/sda1
mkswap /dev/sda2
echo Mounting.
mount /dev/sda3 /mnt
mount --mkdir /dev/sda1 /mnt/boot   
swapon /dev/sda2
echo Installing Software.
pacstrap -K /mnt base linux
echo Generating FSTAB and Rooting
genfstab -U /mnt >> /mnt/etc/fstab
echo Installing git.
echo pacman -S --noconfirm plasma-meta xorg plasma plasma-workspace kde-applications plasma-desktop sddm > script.sh
echo y >> script.sh
cat script.sh | arch-chroot /mnt
echo pacman -S --noconfirm grub efibootmgr networkmanager > script.sh
echo y >> script.sh
cat script.sh | arch-chroot /mnt
echo Creating user.
echo useradd -m -G wheel -s /bin/bash arch > script.sh
echo "echo 'root:arch' | chpasswd" >> script.sh
echo "echo 'arch:arch' | chpasswd" >> script.sh
#time to set kde up
echo systemctl enable sddm.service >> script.sh
echo systemctl enable NetworkManager.service >> script.sh
cat script.sh | arch-chroot /mnt
echo Finished!
echo Restarting in 5.
wait 1s
echo 4.
wait 1s
echo 3.
wait 1s
echo 2.
wait 1s
echo 1.
wait 1s
echo Rebooting!
reboot
