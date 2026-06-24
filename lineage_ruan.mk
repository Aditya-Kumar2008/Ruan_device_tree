#
# Copyright (C) 2024 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
TARGET_SUPPORTS_OMX_SERVICE := false

# Inherit telephony config (5G tablet)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit some common Lineage stuff.
# Tablet device - use tablet config
$(call inherit-product, vendor/lineage/config/common_full_tablet.mk)

# Inherit from ruan device
$(call inherit-product, device/xiaomi/ruan/device.mk)

# Inherit vendor blobs
$(call inherit-product-if-exists, vendor/xiaomi/ruan/ruan-vendor.mk)

# Device identifiers - from stock ROM build.prop
PRODUCT_NAME := lineage_ruan
PRODUCT_DEVICE := ruan
PRODUCT_MANUFACTURER := Xiaomi
PRODUCT_BRAND := Xiaomi
PRODUCT_MODEL := Redmi Pad Pro
PRODUCT_SYSTEM_NAME := ruan_global
PRODUCT_SYSTEM_DEVICE := ruan

# Build prop overrides - matching stock ROM
PRODUCT_BUILD_PROP_OVERRIDES += \
    BuildDesc="ruan_in_global-user 15 AP4A.250205.002 release-keys" \
    BuildFingerprint=Xiaomi/ruan_in_global/ruan:15/AP4A.250205.002:user/release-keys \
    DeviceName=$(PRODUCT_SYSTEM_DEVICE) \
    DeviceProduct=$(PRODUCT_SYSTEM_NAME)

# Eng build options
ifeq ($(TARGET_BUILD_VARIANT),eng)
# Eng build: disable optimization, enable debug, su
PRODUCT_SYSTEM_PROPERTIES += \
    ro.debuggable=1 \
    persist.sys.usb.config=mtp,adb \
    ro.adb.secure=0
endif

# Tablet characteristics
PRODUCT_CHARACTERISTICS := tablet

# GMS properties
PRODUCT_GMS_CLIENTID_BASE := android-xiaomi

# Development / ADB
PRODUCT_SYSTEM_PROPERTIES += \
    persist.service.adb.enable=1 \
    persist.service.debuggable=1 \
    ro.secure=0

# Enable ADB by default
ifeq ($(TARGET_BUILD_VARIANT),userdebug)
PRODUCT_SYSTEM_PROPERTIES += \
    persist.sys.usb.config=mtp,adb \
    ro.adb.secure=0
endif