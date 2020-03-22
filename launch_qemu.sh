STARTUP_RAM=512
NUM_CPUS=2
GUEST_IP=10.0.2.10
#LINUX_KERNEL_SOURCE_PATH=linux_kernels/linux-4.16.1/
LINUX_KERNEL_SOURCE_PATH=linux_kernels/linux-3.14.51/
KERNEL_ZIMAGE_PATH="$LINUX_KERNEL_SOURCE_PATH"arch/arm/boot/zImage
DTB_PATH="$LINUX_KERNEL_SOURCE_PATH"arch/arm/boot/dts/vexpress-v2p-ca15-tc1.dtb


BUILDROOT_PATH=buildroot/
LINUX_ROOTFS_PATH="$BUILDROOT_PATH"output/images/rootfs.ext2

PORT=10022
echo "Using Port: $PORT"

qemu-system-arm \
	-m $STARTUP_RAM \
	-smp $NUM_CPUS \
	-net nic -net user,host=$GUEST_IP,hostfwd=tcp::$PORT-:22 \
	-display none \
	-serial stdio \
	-machine vexpress-a15 \
	-dtb $DTB_PATH \
	-sd "$LINUX_ROOTFS_PATH" \
	-snapshot \
	-kernel $KERNEL_ZIMAGE_PATH \
	-append "earlyprintk=serial console=ttyAMA0 root=/dev/mmcblk0"
