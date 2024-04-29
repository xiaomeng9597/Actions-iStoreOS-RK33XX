#!/bin/bash
#===============================================
# Description: DIY script
# File name: diy-script.sh
# Lisence: MIT
# Author: P3TERX
# Blog: https://p3terx.com
#===============================================

# 移植RK3399 R08


#修改uhttpd配置文件，启用nginx
# sed -i "/.*uhttpd.*/d" .config
# sed -i '/.*\/etc\/init.d.*/d' package/network/services/uhttpd/Makefile
# sed -i '/.*.\/files\/uhttpd.init.*/d' package/network/services/uhttpd/Makefile
sed -i "s/:80/:81/g" package/network/services/uhttpd/files/uhttpd.config
sed -i "s/:443/:4443/g" package/network/services/uhttpd/files/uhttpd.config
cp -a $GITHUB_WORKSPACE/configfiles/etc/* package/base-files/files/etc/
# ls package/base-files/files/etc/





echo -e "\\ndefine Device/rk3399_r08
  DEVICE_VENDOR := RK3399
  DEVICE_MODEL := R08
  SOC := rk3399
  DEVICE_DTS := rk3399-r08
  UBOOT_DEVICE_NAME := r08-rk3399
  IMAGE/sysupgrade.img.gz := boot-common | boot-script | pine64-img | gzip | append-metadata
endef
TARGET_DEVICES += rk3399_r08" >> target/linux/rockchip/image/armv8.mk

cp -f $GITHUB_WORKSPACE/configfiles/Makefile package/boot/uboot-rockchip/Makefile




# 创建rk3399 dts设备树文件夹
mkdir -p target/linux/rockchip/dts/rk3399

cp -f $GITHUB_WORKSPACE/configfiles/rk3399.dtsi target/linux/rockchip/dts/rk3399/rk3399.dtsi
cp -f $GITHUB_WORKSPACE/configfiles/rk3399-opp.dtsi target/linux/rockchip/dts/rk3399/rk3399-opp.dtsi
cp -f $GITHUB_WORKSPACE/configfiles/rk3399-r08.dts target/linux/rockchip/dts/rk3399/rk3399-r08.dts
