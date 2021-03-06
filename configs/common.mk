#
# Copyright (C) 2020 Cygnus
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Version
include vendor/cygnus/configs/version.mk

# Props
include vendor/cygnus/configs/props.mk

# Enable SIP+VoIP
PRODUCT_COPY_FILES += frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

# Disable EAP Proxy because it depends on proprietary headers
# and breaks WPA Supplicant compilation.
DISABLE_EAP_PROXY := true

# Permissions
PRODUCT_COPY_FILES += \
    vendor/cygnus/configs/permissions/privapp-permissions-google-product.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/privapp-permissions-google.xml \
    vendor/cygnus/configs/permissions/privapp-permissions-google.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/privapp-permissions-google.xml

# Include support for GApps backup
PRODUCT_COPY_FILES += \
    vendor/cygnus/prebuilt/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/cygnus/prebuilt/bin/backuptool.functions:install/bin/backuptool.functions \
    vendor/cygnus/prebuilt/bin/50-backuptool.sh:system/addon.d/50-backuptool.sh

ifeq ($(AB_OTA_UPDATER),true)
PRODUCT_COPY_FILES += \
    vendor/cygnus/prebuilt/bin/backuptool_ab.sh:system/bin/backuptool_ab.sh \
    vendor/cygnus/prebuilt/bin/backuptool_ab.functions:system/bin/backuptool_ab.functions \
    vendor/cygnus/prebuilt/bin/backuptool_postinstall.sh:system/bin/backuptool_postinstall.sh
endif

# Copy cygnus specific init file
PRODUCT_COPY_FILES += vendor/cygnus/prebuilt/root/init.cygnus.rc:root/init.cygnus.rc

# Include hostapd configuration
PRODUCT_COPY_FILES += \
    vendor/cygnus/prebuilt/etc/hostapd/hostapd_default.conf:system/etc/hostapd/hostapd_default.conf \
    vendor/cygnus/prebuilt/etc/hostapd/hostapd.deny:system/etc/hostapd/hostapd.deny \
    vendor/cygnus/prebuilt/etc/hostapd/hostapd.accept:system/etc/hostapd/hostapd.accept

# Build Snapdragon apps
PRODUCT_PACKAGES += \
    SnapdragonGallery

# Include support for additional filesystems
PRODUCT_PACKAGES += \
    e2fsck \
    mke2fs \
    tune2fs \
    mount.exfat \
    fsck.exfat \
    mkfs.exfat \
    ntfsfix \
    ntfs-3g

# Bluetooth Audio (A2DP)
PRODUCT_PACKAGES += libbthost_if

# Include explicitly to work around GMS issues
PRODUCT_PACKAGES += libprotobuf-cpp-full

# RCS Service
PRODUCT_PACKAGES += \
    rcscommon \
    rcscommon.xml \
    rcsservice \
    rcs_service_aidl \
    rcs_service_aidl.xml \
    rcs_service_aidl_static \
    rcs_service_api \
    rcs_service_api.xml

# MSIM manual provisioning
PRODUCT_PACKAGES += telephony-ext
PRODUCT_BOOT_JARS += telephony-ext

# TCP Connection Management
PRODUCT_PACKAGES += tcmiface
PRODUCT_BOOT_JARS += tcmiface

# World APN list
PRODUCT_COPY_FILES += \
    vendor/cygnus/prebuilt/etc/apns-conf.xml:system/etc/apns-conf.xml

ifneq ($(HOST_OS),linux)
ifneq ($(sdclang_already_warned),true)
$(warning **********************************************)
$(warning * SDCLANG is not supported on non-linux hosts.)
$(warning **********************************************)
sdclang_already_warned := true
endif
else
# include definitions for SDCLANG
include vendor/cygnus/sdclang/sdclang.mk
endif

# include additional build utilities
include vendor/cygnus/utils.mk

# Cygnus Overlays
include vendor/cygnus-overlays/overlays.mk

# Don't compile SystemUITests
EXCLUDE_SYSTEMUI_TESTS := true

# Disable Java debug info
USE_DEX2OAT_DEBUG := false
PRODUCT_MINIMIZE_JAVA_DEBUG_INFO := true
PRODUCT_ART_TARGET_INCLUDE_DEBUG_BUILD := false

# Launcher
PRODUCT_PACKAGES += \
    TrebuchetQuickStep

# Prebuilt Packages
PRODUCT_PACKAGES += \
	MiXplorerPrebuilt \
	RetroMusicPlayer \
	ViaBrowser

# Bootanimation
ifeq ($(TARGET_BOOT_ANIMATION_RES),1080)
     PRODUCT_COPY_FILES += vendor/cygnus/bootanimation/bootanimation-dark_1080.zip:$(TARGET_COPY_OUT_PRODUCT)/media/bootanimation.zip
else ifeq ($(TARGET_BOOT_ANIMATION_RES),1440)
     PRODUCT_COPY_FILES += vendor/cygnus/bootanimation/bootanimation-dark_1440.zip:$(TARGET_COPY_OUT_PRODUCT)/media/bootanimation.zip
else ifeq ($(TARGET_BOOT_ANIMATION_RES),720)
     PRODUCT_COPY_FILES += vendor/cygnus/bootanimation/bootanimation-dark_720.zip:$(TARGET_COPY_OUT_PRODUCT)/media/bootanimation.zip
else
    ifeq ($(TARGET_BOOT_ANIMATION_RES),)
        $(warning "Cygnus: TARGET_BOOT_ANIMATION_RES is undefined, assuming 1080p")
    else
        $(warning "Cygnus: Current bootanimation res is not supported, forcing 1080p")
    endif
    PRODUCT_COPY_FILES += vendor/cygnus/bootanimation/bootanimation-dark_1080.zip:$(TARGET_COPY_OUT_PRODUCT)/media/bootanimation.zip
endif

ifeq ($(WITH_GAPPS),true)
      GAPPS_VARIANT := pico
      GAPPS_FORCE_PACKAGE_OVERRIDES := true
      GAPPS_PRODUCT_PACKAGES += CalendarGooglePrebuilt
      include vendor/opengapps/build/opengapps-packages.mk
endif
