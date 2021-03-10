# UPxtreme-RT-kernel
PREEMPT_RT kernel on UP! Xtreme

## Lets get started!

``mkdir ~/kernel``
``cd ~/kernel``
``git clone https://github.com/AaeonCM/ubuntu-bionic-up.git``
``cd ubuntu-bionic-up``
``git checkout hwe-5.4-upboard``
``make kernelversion`` --Gives information on kernel version-- in my case (5.4.65)--

## Find RT patch equal or close to kernel version from make kernelversion output---

``wget https://mirrors.edge.kernel.org/pub/linux/kernel/projects/rt/5.4/older/patch-5.4.66-rt38.patch.xz``
``unxz -cd patch-5.4.66-rt38.patch.xz | patch -p1``

``some step here.``
``xdg-open .config``

## Apply RT OPTIONS on kernel
``HIGH_RES_TIMERS=y
CONFIG_PREEMPT_RT_FULL=y
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_OF=n``

## IF ``make`` fails turn off AUFS
``CONFIG_AUFS_FS=n``

## Option
disable the CPU idle state and to set the default CPU frequency governor to performance

``CONFIG_CPU_IDLE=n
CONFIG_INTEL_IDLE=n
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y``

## Option isolcpus 
To check.

``make``   (NOTE: You can use “make -jX” option if you have thread support. X is number of core + 1. It will compile faster)

## Make modules and install
``sudo make modules_install -j2``
``sudo make install -j2``

## Check new kernel file and update grub boot loader to start Linux with new RT-Kernel
``cd /boot``
``ls``

You will see new kernel. (UPDATE TEXT HERE)

## Update grub and reboot machine
``sudo update-grub``
``sudo reboot``

## Check kernel version to be sure.
``uname -a``



## Install upboard-extras
``sudo apt install upboard-extras``

