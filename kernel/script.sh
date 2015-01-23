#!/sbin/sh
cd /tmp/
busybox dd if=/dev/block/mmcblk0p17 of=/tmp/boot.img
/tmp/unpackbootimg /tmp/boot.img
mkdir /tmp/b
mv /tmp/boot.img-ramdisk.gz /tmp/b/boot.img-ramdisk.gz
cd /tmp/b
busybox gunzip -c boot.img-ramdisk.gz | cpio -i
rm boot.img-ramdisk.gz
rm sbin/ramdisk-recovery.cpio
mv /tmp/ramdisk-recovery.cpio /tmp/b/sbin/ramdisk-recovery.cpio
busybox find . | cpio -H newc -o | gzip > /tmp/new-ramdisk.gz
/tmp/mkbootimg --kernel /tmp/boot.img-zImage --ramdisk /tmp/new-ramdisk.gz --cmdline 'panic=3 console=ttyHSL0,115200,n8 androidboot.hardware=qcom user_debug=31 msm_rtb.filter=0x3F ehci-hcd.park=3' --base 0x80200000  --ramdiskaddr 0x82200000 -o /tmp/newboot.img
busybox dd if=/tmp/newboot.img of=/dev/block/mmcblk0p17
