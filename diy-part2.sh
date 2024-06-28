#!/bin/bash
#===============================================
# Description: DIY script
# File name: diy-script.sh
# Lisence: MIT
# Author: P3TERX
# Blog: https://p3terx.com
#===============================================


# update ubus git HEAD
cp -f $GITHUB_WORKSPACE/configfiles/ubus_Makefile package/system/ubus/Makefile


# 近期istoreos网站文件服务器不稳定，临时增加一个自定义下载网址
sed -i "s/push @mirrors, 'https:\/\/mirror2.openwrt.org\/sources';/&\\npush @mirrors, 'https:\/\/github.com\/xiaomeng9597\/files\/releases\/download\/iStoreosFile';/g" scripts/download.pl


#修改uhttpd配置文件，启用nginx
# sed -i "/.*uhttpd.*/d" .config
# sed -i '/.*\/etc\/init.d.*/d' package/network/services/uhttpd/Makefile
# sed -i '/.*.\/files\/uhttpd.init.*/d' package/network/services/uhttpd/Makefile
sed -i "s/:80/:81/g" package/network/services/uhttpd/files/uhttpd.config
sed -i "s/:443/:4443/g" package/network/services/uhttpd/files/uhttpd.config
cp -a $GITHUB_WORKSPACE/configfiles/etc/* package/base-files/files/etc/
# ls package/base-files/files/etc/






# 移植以下机型
# RK3399 R08
# RK3399 TPM312

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


echo -e "\\ndefine Device/rk3399_tpm312
  DEVICE_VENDOR := RK3399
  DEVICE_MODEL := TPM312
  SOC := rk3399
  SUPPORTED_DEVICES := rk3399,tpm312
  DEVICE_DTS := rk3399-tpm312
  UBOOT_DEVICE_NAME := tpm312-rk3399
  IMAGE/sysupgrade.img.gz := boot-common | boot-script | pine64-img | gzip | append-metadata
endef
TARGET_DEVICES += rk3399_tpm312" >> target/linux/rockchip/image/armv8.mk





cp -f $GITHUB_WORKSPACE/configfiles/r08-rk3399_defconfig package/boot/uboot-rockchip/src/configs/r08-rk3399_defconfig
cp -f $GITHUB_WORKSPACE/configfiles/tpm312-rk3399_defconfig package/boot/uboot-rockchip/src/configs/tpm312-rk3399_defconfig



# 网口配置为旁路由模式，注释下面三个网口模式替换命令后，网口模式会变成主路由模式。
sed -i "s/armsom,p2pro)/armsom,p2pro|\\\\\n	rk3399,r08)/g" target/linux/rockchip/armv8/base-files/etc/board.d/02_network
sed -i "s/rk3399,r08)/rk3399,r08|\\\\\n	rk3399,tpm312)/g" target/linux/rockchip/armv8/base-files/etc/board.d/02_network




# 复制和修改u-boot压缩包SHA256校验码，编译失败时注意看是不是这个引起的。
cp -f $GITHUB_WORKSPACE/configfiles/uboot_Makefile package/boot/uboot-rockchip/Makefile
sha256_value=$(wget -qO- "https://github.com/xiaomeng9597/files/releases/download/u-boot-2021.07/u-boot-2021.07.tar.bz2.sha" | awk '{print $1}')
if [ -n "$sha256_value" ]; then
sed -i "s/.*PKG_HASH:=.*/PKG_HASH:=$sha256_value/g" package/boot/uboot-rockchip/Makefile
fi
cp -f $GITHUB_WORKSPACE/configfiles/u-boot.mk include/u-boot.mk





# 创建rk3399 dts设备树文件夹
mkdir -p target/linux/rockchip/dts/rk3399

cp -f $GITHUB_WORKSPACE/configfiles/rk3399.dtsi target/linux/rockchip/dts/rk3399/rk3399.dtsi
cp -f $GITHUB_WORKSPACE/configfiles/rk3399-opp.dtsi target/linux/rockchip/dts/rk3399/rk3399-opp.dtsi
cp -f $GITHUB_WORKSPACE/configfiles/rk3399-r08.dts target/linux/rockchip/dts/rk3399/rk3399-r08.dts
cp -f $GITHUB_WORKSPACE/configfiles/rk3399-tpm312.dts target/linux/rockchip/dts/rk3399/rk3399-tpm312.dts


cp -f $GITHUB_WORKSPACE/configfiles/rk3399.dtsi target/linux/rockchip/armv8/files/arch/arm64/boot/dts/rockchip/rk3399.dtsi
cp -f $GITHUB_WORKSPACE/configfiles/rk3399-opp.dtsi target/linux/rockchip/armv8/files/arch/arm64/boot/dts/rockchip/rk3399-opp.dtsi
cp -f $GITHUB_WORKSPACE/configfiles/rk3399-r08.dts target/linux/rockchip/armv8/files/arch/arm64/boot/dts/rockchip/rk3399-r08.dts
cp -f $GITHUB_WORKSPACE/configfiles/rk3399-tpm312.dts target/linux/rockchip/armv8/files/arch/arm64/boot/dts/rockchip/rk3399-tpm312.dts


cp -f $GITHUB_WORKSPACE/configfiles/rk3399.dtsi package/boot/uboot-rockchip/src/arch/arm/dts/rk3399.dtsi
cp -f $GITHUB_WORKSPACE/configfiles/rk3399-opp.dtsi package/boot/uboot-rockchip/src/arch/arm/dts/rk3399-opp.dtsi
cp -f $GITHUB_WORKSPACE/configfiles/rk3399-r08.dts package/boot/uboot-rockchip/src/arch/arm/dts/rk3399-r08.dts
cp -f $GITHUB_WORKSPACE/configfiles/rk3399-tpm312.dts package/boot/uboot-rockchip/src/arch/arm/dts/rk3399-tpm312.dts


#开启无线功能，已移除Realtek相关无线驱动，暂时这个不可用，原因兼容性不好，异常掉线
# cp -f $GITHUB_WORKSPACE/configfiles/opwifi package/base-files/files/etc/init.d/opwifi
# chmod 755 package/base-files/files/etc/init.d/opwifi
# sed -i "s/wireless.radio\${devidx}.disabled=1/wireless.radio\${devidx}.disabled=0/g" package/kernel/mac80211/files/lib/wifi/mac80211.sh


#集成CPU性能跑分脚本
cp -a $GITHUB_WORKSPACE/configfiles/coremark/* package/base-files/files/bin/
chmod 755 package/base-files/files/bin/coremark
chmod 755 package/base-files/files/bin/coremark.sh
