echo n > script.txt
echo p >> script.txt
echo 1 >> script.txt
echo -en '\n' >> script.txt
echo +1G >> script.txt
echo n >> script.txt
echo p >> script.txt
echo 2 >> script.txt
echo -en '\n' >> script.txt
echo +4G >> script.txt
echo n >> script.txt
echo p >> script.txt
echo 3 >> script.txt
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
echo pacman -S --noconfirm plasma-meta > script.sh
echo y >> script.sh
cat script.sh | arch-chroot /mnt
echo pacman -S --noconfirm grub efibootmgr> script.sh
echo y >> script.sh
cat script.sh | arch-chroot /mnt
echo grub-install /dev/sda --efi-directory=/boot > script.sh # install grub 
echo 'sed -i '\''s/#GRUB_DISABLE_OS_PROBER=false/GRUB_DISABLE_OS_PROBER=false/g'\'' /etc/default/grub' >> script.sh
echo grub-mkconfig -o /boot/grub/grub.cfg >> script.sh
cat script.sh | arch-chroot /mnt
echo Creating user.
echo useradd -m -G wheel -s /bin/bash arch > script.sh
echo "echo 'root:arch' | chpasswd" >> script.sh
echo "echo 'arch:arch' | chpasswd" >> script.sh
cat script.sh | arch-chroot /mnt
echo Finished!
reboot
