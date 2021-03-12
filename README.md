# UPXtreme-RT-kernel
Custom PREEMPT_RT kernel on UP! Xtreme based on UP! kernel hwe-5.4-upboard.
Only tested on UP Xtreme i7C1-8565U

### Disclaimer: use at your own risk!

## Lets get started!

``sudo apt install build-essential fakeroot dpkg-dev perl libssl-dev bc gnupg dirmngr libncurses5-dev libelf-dev flex bison``

``mkdir ~/kernel``

``cd ~/kernel``

``git clone https://github.com/AaeonCM/ubuntu-bionic-up.git``

``cd ubuntu-bionic-up``

``git checkout hwe-5.4-upboard``

``make kernelversion`` --Gives information on kernel version-- in my case (5.4.65)--

## Find RT patch equal or close to kernel version from make kernelversion output---

``wget https://mirrors.edge.kernel.org/pub/linux/kernel/projects/rt/5.4/older/patch-5.4.66-rt38.patch.xz``

``unxz -cd patch-5.4.66-rt38.patch.xz | patch -p1``

---------------------------
# Create the kernel .config (options 1 or 2)

1. ``cp /boot/config-5.4.0-1-generic .config``

2. ``make defconfig``

---------------------------

# Configure the kernel (options 1 or 2)

1. ``xdg-open .config`` (text based)

2. ``make menuconfig`` (GUI based)


## Apply RT OPTIONS on kernel
``HIGH_RES_TIMERS=y``

``CONFIG_PREEMPT_RT=y``

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

![RT](https://user-images.githubusercontent.com/6362413/110859289-819d5880-82bb-11eb-85ef-bf8effec5ab8.PNG)


## Real time test using latency plot under the stress
Note: adjust CPU cores on line 2 and 11 in rt-test.sh

``sudo apt install rt-tests stress gnuplot`` 

``mkdir ~/plot``

``cd ~/plot``

``git clone https://github.com/QiayuanLiao/Ubuntu-RT-UP-Board.git``

``cd ~/Ubuntu-RT-UP-Board``

``cd ~/test``

``sudo sh  ./rt-test.sh``

![11111](https://user-images.githubusercontent.com/6362413/110928261-f9549d00-8326-11eb-8fd7-2f6ee0ad353e.PNG)



## rt-can-test is to provide an easy way to test the performance of the Linux PREEMPT_RT patches together with CAN.
The following tests has been performed on https://www.peak-system.com/PCAN-M-2.473.0.html?&L=1 (PCAN-M.2 Four Channel) mounted on UP Xtreme i7C1-8565U (https://up-board.org/up-xtreme/) and transmit CAN message to a moteus r4.5 controller (https://mjbots.com/products/moteus-r4-5) with ID:1

``cd ~/repos``

``git clone https://github.com/erstrom/rt-can-test.git``

``cd ~/rt-can-test``

``sudo make``

``sudo make install``

## Configure CAN interface (socket CAN API)
Adapter such as the PEAK-CAN-FD use a 80MHz clock. The following timings have been observed to work (from https://github.com/mjbots/moteus/blob/main/docs/reference.md#80-mhz-clock-systems)

```
sudo ip link set can3 up type can \
  tq 12 prop-seg 25 phase-seg1 25 phase-seg2 29 sjw 10 \
  dtq 12 dprop-seg 6 dphase-seg1 2 dphase-seg2 7 dsjw 12 \
  restart-ms 1000 fd on
```

# 100 ms (10 Hz)
``sudo rt-can-test --if can3 --tx 00008001##1420120 -i 100000 -r -v``

snippet from console output
```
[ 16719.938193] TX: 100##1410100
[ 16719.939749] RX: 100##1410100
[ 16720.038242] TX: 100##1410100
[ 16720.039670] RX: 100##1410100
[ 16720.138278] TX: 100##1410100
[ 16720.139730] RX: 100##1410100

```

# 10ms (100hz)
``sudo rt-can-test --if can3 --tx 00008001##1420120 -i 10000 -r -v``

snippet from console output 
```
[ 16681.619501] TX: 100##1410100
[ 16681.620853] RX: 100##1410100
[ 16681.629555] TX: 100##1410100
[ 16681.630995] RX: 100##1410100
[ 16681.639611] TX: 100##1410100
[ 16681.641081] RX: 100##1410100
```

# 1ms (1000hz)
``sudo rt-can-test --if can3 --tx 00008001##1420120 -i 1000 -r -v``

snippet from console output 
```
[ 16874.632739] TX: 100##1410100
[ 16874.633044] RX: 100##1410100
[ 16874.633064] RX: 100##1410100
[ 16874.633748] TX: 100##1410100
[ 16874.634755] TX: 100##1410100
[ 16874.635035] RX: 100##1410100
```


## Extras (notes)
Remove custom kernel

``locate -b -e 5.4.65-rt38+``

remove 

``locate -b -e 5.4.65-rt38+ | xargs -p sudo rm -r``

``sudo update-grub``

``cd /boot/``

``ls``


# Real-time Optimization (to test)
One of the contributors to latency in the Voluntary Preemption and Preemptible Kernel models are console messages written to a serial console. Serial console messages may be minimized by using the kernel argument quiet. To suppress messages after boot, use the following line to only enable emergency messages: Source (https://developer.toradex.com/knowledge-base/real-time-linux)

``echo 1 > /proc/sys/kernel/printk``

``kernel.printk = 1 4 1 7``

``echo 2 > /proc/sys/vm/overcommit_memory``

``vm.overcommit_memory = 2``































