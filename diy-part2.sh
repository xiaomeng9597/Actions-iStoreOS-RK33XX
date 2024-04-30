#!/bin/bash
#===============================================
# Description: DIY script
# File name: diy-script.sh
# Lisence: MIT
# Author: P3TERX
# Blog: https://p3terx.com
#===============================================


#修改uhttpd配置文件，启用nginx
# sed -i "/.*uhttpd.*/d" .config
# sed -i '/.*\/etc\/init.d.*/d' package/network/services/uhttpd/Makefile
# sed -i '/.*.\/files\/uhttpd.init.*/d' package/network/services/uhttpd/Makefile
sed -i "s/:80/:81/g" package/network/services/uhttpd/files/uhttpd.config
sed -i "s/:443/:4443/g" package/network/services/uhttpd/files/uhttpd.config
# cp -a $GITHUB_WORKSPACE/configfiles/etc/* package/base-files/files/etc/
# ls package/base-files/files/etc/





# 移植RK3399 R08

echo -e "\\ndefine Device/rk3399_r08
  DEVICE_VENDOR := RK3399
  DEVICE_MODEL := R08
  SOC := rk3399
  SUPPORTED_DEVICES := rk3399,r08
  UBOOT_DEVICE_NAME := r08-rk3399
  IMAGE/sysupgrade.img.gz := boot-common | boot-script | pine64-img | gzip | append-metadata
endef
TARGET_DEVICES += rk3399_r08" >> target/linux/rockchip/image/armv8.mk







cp -f $GITHUB_WORKSPACE/configfiles/Makefile package/boot/uboot-rockchip/Makefile


# cp -f $GITHUB_WORKSPACE/configfiles/r08-rk3399_defconfig package/boot/uboot-rockchip/src/configs/r08-rk3399_defconfig


sed -i "s/armsom,p2pro)/armsom,p2pro|\\\\\n	rk3399,r08)/g" target/linux/rockchip/armv8/base-files/etc/board.d/02_network


#cp -f $GITHUB_WORKSPACE/configfiles/0990-add-board-r08-dts.patch package/boot/uboot-rockchip/patches/0990-add-board-r08-dts.patch


sed -i "s/.*PKG_HASH:=.*/PKG_HASH:=fb3c470254c4d5260fab9b4d5a6d11cabf65e5166bce4d29da446fe158af8eb2/g" package/boot/uboot-rockchip/Makefile
cp -f $GITHUB_WORKSPACE/configfiles/u-boot.mk include/u-boot.mk
