# UPXtreme-RT-kernel
Custom PREEMPT_RT kernel on UP! Xtreme based on UP! kernel hwe-5.4-upboard.
Only tested on UP Xtreme i7C1-8565U

### Disclaimer: use at your own risk!

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

``make defconfig``

``xdg-open .config``

## Apply RT OPTIONS on kernel
``HIGH_RES_TIMERS=y``

``CONFIG_PREEMPT_RT_FULL=y``

``CONFIG_HZ_1000=y``

``CONFIG_HZ=1000``

``CONFIG_OF=n``

## IF ``make`` fails turn off AUFS
``CONFIG_AUFS_FS=n``

## Optional
disable the CPU idle state and to set the default CPU frequency governor to performance

``CONFIG_CPU_IDLE=n``

``CONFIG_INTEL_IDLE=n``

``CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y``

## Optional isolcpus 
To check.


## Building 

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

``cd ~/temp``

``wget https://github.com/raess1/UPxtreme-RT-kernel/blob/main/permissiongroups.sh``

``chmod +x permissiongroups.sh``

``./permissiongroups.sh``

after that you need to add the user that needs to access the HAT functionality to the corresponding groups:

GPIO
``sudo usermod -a -G gpio ${USER}``

LEDs
``sudo usermod -a -G leds ${USER}``

SPI
``sudo usermod -a -G spi ${USER}``

I2C
``sudo usermod -a -G i2c ${USER}``

UART
``sudo usermod -a -G dialout ${USER}``

to apply the permission changes after issuing the previous command a reboot is needed
``sudo reboot``

## GPIO test
``echo 26 > /sys/class/gpio/export``
``echo out > /sys/class/gpio/gpio26/direction``
``echo 1 > /sys/class/gpio/gpio26/value``
Should make pin37 output 3.3v (measure)

``echo 0 > /sys/class/gpio/gpio26/value``
Should make pin37  output 0V (measure)

## LED test

The UP Board includes 3 LEDs (yellow, green, red) on the underside of the board (underneath the 4 USB2.0 Type-A sockets), which are controlled by the pin control CPLD on the board. As root, you can use the following commands to control the LEDs:

``echo 1 > /sys/class/leds/upboard\:green\:/brightness``
``echo 0 > /sys/class/leds/upboard\:green\:/brightness``

## RT-Tests
``sudo apt-get install build-essential libnuma-dev``

``mkdir ~/rt``

``cd ~/rt``

``git clone git://git.kernel.org/pub/scm/utils/rt-tests/rt-tests.git``

``cd rt-tests``

``git checkout stable/v1.0``

``make all``

``make install``

## Run tests
To run one test thread per CPU or per CPU core, each thread on a separate processor, type
``sudo ./cyclictest -a -t -n -p99``

## Benching from 5.4.0-1-generic #0~upboard2-Ubuntu SMP vs RT 
On a non-realtime system, you may see something like

T: 0 ( 1946) P:99 I:1000 C:   21097 Min:      1 Act:    3 Avg:    2 Max:      177

T: 1 ( 1947) P:99 I:1500 C:   14064 Min:      1 Act:    3 Avg:    3 Max:      152

T: 2 ( 1948) P:99 I:2000 C:   10548 Min:      1 Act:    1 Avg:    3 Max:      152

T: 3 ( 1949) P:99 I:2500 C:   8439 Min:      1 Act:    3 Avg:    3 Max:      168

T: 4 ( 1950) P:99 I:3000 C:   7032 Min:      1 Act:    3 Avg:    3 Max:      139

T: 5 ( 1951) P:99 I:3500 C:   6027 Min:      1 Act:    3 Avg:    3 Max:      169

T: 6 ( 1952) P:99 I:4000 C:   5274 Min:      1 Act:    3 Avg:    3 Max:      170

T: 7 ( 1953) P:99 I:4500 C:   4688 Min:      1 Act:    2 Avg:    4 Max:      123


RT-PREEMPT

T: 0 ( 4614) P:99 I:1000 C:   5507 Min:      1 Act:    3 Avg:    3 Max:      30

T: 1 ( 4615) P:99 I:1500 C:   3671 Min:      1 Act:    4 Avg:    3 Max:      26

T: 2 ( 4616) P:99 I:2000 C:   2753 Min:      1 Act:    6 Avg:    3 Max:      23

T: 3 ( 4617) P:99 I:2500 C:   2202 Min:      2 Act:    6 Avg:    3 Max:      30

T: 4 ( 4618) P:99 I:3000 C:   1835 Min:      2 Act:    7 Avg:    3 Max:      11

T: 5 ( 4619) P:99 I:3500 C:   1573 Min:      1 Act:    5 Avg:    3 Max:      36

T: 6 ( 4620) P:99 I:4000 C:   1376 Min:      1 Act:    4 Avg:    3 Max:      42

T: 7 ( 4621) P:99 I:4500 C:   1223 Min:      2 Act:    4 Avg:    4 Max:      21














