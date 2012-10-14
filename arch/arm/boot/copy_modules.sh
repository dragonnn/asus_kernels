#!/bin/bash

rm -fr ./system
mkdir -p ./system/lib/modules
cp ../../../drivers/net/usb/raw_ip_net.ko ./system/lib/modules/
cp ../../../drivers/net/wireless/bcm4329/bcm4329.ko ./system/lib/modules/
cp ../../../drivers/net/wireless/bcmdhd_29/bcmdhd_29.ko ./system/lib/modules/
cp ../../../drivers/net/wireless/bcmdhd/bcmdhd.ko ./system/lib/modules/
cp ../../../drivers/net/wireless/bcmdhd_34/bcmdhd_34.ko ./system/lib/modules/
cp ../../../drivers/usb/serial/baseband_usb_chr.ko ./system/lib/modules/
cp ../../../net/wireless/cfg80211.ko ./system/lib/modules/