#!/bin/sh
 set -e
 
 for group in gpio leds spi i2c; do
 	if ! getent group $group >/dev/null; then
 		addgroup --system $group
 	fi
 done
