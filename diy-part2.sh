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
cp -a $GITHUB_WORKSPACE/configfiles/etc/* package/base-files/files/etc/
# ls package/base-files/files/etc/





# 移植RK3399 R08 和 xiaobao-nas-v1

echo -e "\\ndefine Device/rk3399_r08
  DEVICE_VENDOR := RK3399
  DEVICE_MODEL := R08
  SOC := rk3399
  SUPPORTED_DEVICES := rk3399,r08
  DEVICE_DTS := rk3399-r08
  UBOOT_DEVICE_NAME := r08-rk3399
  IMAGE/sysupgrade.img.gz := boot-common | boot-script | pine64-img | gzip | append-metadata
endef
TARGET_DEVICES += rk3399_r08" >> target/linux/rockchip/image/armv8.mk


echo -e "\\ndefine Device/codinge_xiaobao-nas-v1
  DEVICE_VENDOR := Codinge
  DEVICE_MODEL := XiaoBao NAS-I
  SOC := rk3399
  SUPPORTED_DEVICES := codinge,xiaobao-nas-v1
  DEVICE_DTS := rk3399-xiaobao-nas-v1
  UBOOT_DEVICE_NAME := xiaobao-nas-v1-rk3399
  IMAGE/sysupgrade.img.gz := boot-common | boot-script | pine64-img | gzip | append-metadata
  DEVICE_PACKAGES := kmod-ata-ahci
endef
TARGET_DEVICES += codinge_xiaobao-nas-v1" >> target/linux/rockchip/image/armv8.mk





cp -f $GITHUB_WORKSPACE/configfiles/r08-rk3399_defconfig package/boot/uboot-rockchip/src/configs/r08-rk3399_defconfig
cp -f $GITHUB_WORKSPACE/configfiles/xiaobao-nas-v1-rk3399_defconfig package/boot/uboot-rockchip/src/configs/xiaobao-nas-v1-rk3399_defconfig



# 网口配置
sed -i "s/friendlyarm,nanopi-r2s|\\\/friendlyarm,nanopi-r2s|\\\\\n	rk3399,r08|\\\/g" target/linux/rockchip/armv8/base-files/etc/board.d/02_network
sed -i "s/rk3399,r08|\\\/rk3399,r08|\\\\\n	codinge,xiaobao-nas-v1|\\\/g" target/linux/rockchip/armv8/base-files/etc/board.d/02_network

sed -i "s/friendlyarm,nanopi-r2s)/friendlyarm,nanopi-r2s|\\\\\n	rk3399,r08)/g" target/linux/rockchip/armv8/base-files/etc/board.d/02_network
sed -i "s/rk3399,r08)/rk3399,r08|\\\\\n	codinge,xiaobao-nas-v1)/g" target/linux/rockchip/armv8/base-files/etc/board.d/02_network



# cp -f $GITHUB_WORKSPACE/configfiles/0990-add-board-r08-dts.patch package/boot/uboot-rockchip/patches/0990-add-board-r08-dts.patch


cp -f $GITHUB_WORKSPACE/configfiles/Makefile package/boot/uboot-rockchip/Makefile
sed -i "s/.*PKG_HASH:=.*/PKG_HASH:=5cb97de15c90002831ed964b817ca56500248a9285b4715680ac7e5e3fe37bed/g" package/boot/uboot-rockchip/Makefile
cp -f $GITHUB_WORKSPACE/configfiles/u-boot.mk include/u-boot.mk





# 创建rk3399 dts设备树文件夹
mkdir -p target/linux/rockchip/dts/rk3399

cp -f $GITHUB_WORKSPACE/configfiles/rk3399.dtsi target/linux/rockchip/dts/rk3399/rk3399.dtsi
cp -f $GITHUB_WORKSPACE/configfiles/rk3399-opp.dtsi target/linux/rockchip/dts/rk3399/rk3399-opp.dtsi
cp -f $GITHUB_WORKSPACE/configfiles/rk3399-r08.dts target/linux/rockchip/dts/rk3399/rk3399-r08.dts
cp -f $GITHUB_WORKSPACE/configfiles/rk3399-xiaobao-nas-v1.dts target/linux/rockchip/dts/rk3399/rk3399-xiaobao-nas-v1.dts


cp -f $GITHUB_WORKSPACE/configfiles/rk3399.dtsi target/linux/rockchip/armv8/files/arch/arm64/boot/dts/rockchip/rk3399.dtsi
cp -f $GITHUB_WORKSPACE/configfiles/rk3399-opp.dtsi target/linux/rockchip/armv8/files/arch/arm64/boot/dts/rockchip/rk3399-opp.dtsi
cp -f $GITHUB_WORKSPACE/configfiles/rk3399-r08.dts target/linux/rockchip/armv8/files/arch/arm64/boot/dts/rockchip/rk3399-r08.dts
cp -f $GITHUB_WORKSPACE/configfiles/rk3399-xiaobao-nas-v1.dts target/linux/rockchip/armv8/files/arch/arm64/boot/dts/rockchip/rk3399-xiaobao-nas-v1.dts


cp -f $GITHUB_WORKSPACE/configfiles/rk3399.dtsi package/boot/uboot-rockchip/src/arch/arm/dts/rk3399.dtsi
cp -f $GITHUB_WORKSPACE/configfiles/rk3399-opp.dtsi package/boot/uboot-rockchip/src/arch/arm/dts/rk3399-opp.dtsi
cp -f $GITHUB_WORKSPACE/configfiles/rk3399-r08.dts package/boot/uboot-rockchip/src/arch/arm/dts/rk3399-r08.dts
cp -f $GITHUB_WORKSPACE/configfiles/rk3399-xiaobao-nas-v1.dts package/boot/uboot-rockchip/src/arch/arm/dts/rk3399-xiaobao-nas-v1.dts



#集成CPU性能跑分脚本
cp -a $GITHUB_WORKSPACE/configfiles/coremark/* package/base-files/files/sbin/
chmod 755 package/base-files/files/sbin/coremark
chmod 755 package/base-files/files/sbin/coremark.sh
