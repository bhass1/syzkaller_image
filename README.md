# Syzkaller Image
Contains customizations for getting syzkaller to work with Linux kernels on QEMU

## Linux Kernels
Currently supporting:

    - linux-4.16.1 - Includes KCOV and base-line patches recommended by Syzkaller project

Work In Progress:

    - linux-3.14.51 - Just a basic linux kernel right now

## QEMU Config
Syzkaller needs a config file. The default provided config file doens't work out-of-the-box.

    - qemu.cfg - point syzkaller at this QEMU Config file

# Launch QEMU
Helper script to test whether QEMU can launch the kernel, dtb, and rootfs successfully
