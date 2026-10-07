#
# Copyright (C) 2021-2026 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# AAPT
PRODUCT_AAPT_CONFIG := normal
PRODUCT_AAPT_PREF_CONFIG := xxxhdpi

# Alert slider
PRODUCT_PACKAGES += \
    KeyHandler \
    tri-state-key-calibrate

# Audio
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/audio/audio_platform_info_intcodec.xml:$(TARGET_COPY_OUT_ODM)/etc/audio_platform_info.xml \
    $(LOCAL_PATH)/audio/audio_platform_info_intcodec.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/sku_lahaina/audio_platform_info_intcodec.xml \
    $(LOCAL_PATH)/audio/mixer_paths.xml:$(TARGET_COPY_OUT_ODM)/etc/mixer_paths.xml \
    $(LOCAL_PATH)/audio/mixer_paths.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/sku_lahaina/mixer_paths.xml \
    $(LOCAL_PATH)/audio/sound_trigger_mixer_paths.xml:$(TARGET_COPY_OUT_ODM)/etc/sound_trigger_mixer_paths.xml \
    $(LOCAL_PATH)/audio/sound_trigger_mixer_paths.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/sku_lahaina/sound_trigger_mixer_paths.xml \
    $(LOCAL_PATH)/audio/sound_trigger_platform_info.xml:$(TARGET_COPY_OUT_ODM)/etc/sound_trigger_platform_info.xml \
    $(LOCAL_PATH)/audio/sound_trigger_platform_info.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/sku_lahaina/sound_trigger_platform_info.xml

# Boot animation
TARGET_SCREEN_HEIGHT := 2412
TARGET_SCREEN_WIDTH := 1080

# Camera
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/media/media_profiles_vendor.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_profiles_vendor.xml

# Display
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/display/displayconfig.xml:$(TARGET_COPY_OUT_VENDOR)/etc/displayconfig/display_id_4630946292801050754.xml

# Lineage Health
$(call soong_config_set,lineage_health,charging_control_charging_path,/sys/class/oplus_chg/battery/chg_enable)

# LiveDisplay: PictureAdjustment defaults to ON in hardware/oplus's
# vendor.lineage.livedisplay-service.oplus (see aidl/livedisplay/README.md), but
# on this device its backend is vendor.lineage.livedisplay::sdm::PictureAdjustment
# (SDMController -> SDM/DPPS ColorManager), which answers every call with
# "Client: 2 is not active" / UNSUPPORTED_OPERATION. LiveDisplayService's boot-phase
# PictureAdjustmentController doesn't catch that, so it throws all the way up to a
# FATAL EXCEPTION IN SYSTEM PROCESS and kills system_server -- the display "break
# loop". Disabling it here removes the AIDL registration entirely, which
# LineageHardwareManager already handles gracefully (same as the AB/AF/DM
# features, which default off and cause zero crashes).
$(call soong_config_set_bool,OPLUS_LINEAGE_LIVEDISPLAY_HAL,ENABLE_PA,false)

# bionic: force composer/hwc/gralloc HAL binaries onto Scudo instead of the
# jemalloc carve-out bionic/libc/Android.bp's display_jemalloc_defaults grants
# them by default (should_use_jemalloc_for_display() in malloc_common.cpp).
$(call soong_config_set,BIONIC,use_jemalloc_for_display_stack,false)

# NFC
PRODUCT_PACKAGES += \
    android.hardware.nfc-service.nxp \
    com.android.nfc_extras \
    Tag

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.nfc.ese.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.ese.xml \
    frameworks/native/data/etc/android.hardware.nfc.hce.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.hce.xml \
    frameworks/native/data/etc/android.hardware.nfc.hcef.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.hcef.xml \
    frameworks/native/data/etc/android.hardware.nfc.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.xml \
    frameworks/native/data/etc/android.hardware.se.omapi.ese.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.se.omapi.ese.xml \
    frameworks/native/data/etc/android.hardware.se.omapi.uicc.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.se.omapi.uicc.xml \
    frameworks/native/data/etc/com.android.nfc_extras.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/com.android.nfc_extras.xml \
    frameworks/native/data/etc/com.nxp.mifare.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/com.nxp.mifare.xml

# Overlays
DEVICE_PACKAGE_OVERLAYS += \
    $(LOCAL_PATH)/overlay-lineage

PRODUCT_PACKAGES += \
    KeyHandlerResTarget \
    OPlusFrameworksResTarget \
    OPlusSettingsProviderResTarget \
    OPlusSettingsResTarget \
    OPlusSystemUIResTarget

# PowerShare
PRODUCT_PACKAGES += \
    vendor.lineage.powershare-service.oplus

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH)

# Axion OS Custom Flags
TARGET_DISABLE_EPPE := true
AXION_CAMERA_REAR_INFO := 50,48,8,2
AXION_CAMERA_FRONT_INFO := 16
BYPASS_CHARGE_SUPPORTED ?= true
AXION_MAINTAINER := Tony01
AXION_PROCESSOR := Qualcomm®_Snapdragon™_888
# PartnerPkgs (SetupWizardPrebuilt/SetupWizardPixelPrebuilt) pulls in Google's
# own OOBE flow, whose OpaWrapper (Assistant opt-in) step launches an intent
# into com.google.android.googlequicksearchbox (Velvet) unconditionally. This
# build's TARGET_GAPPS_VARIANT=core never installs Velvet, and OpaWrapper's
# own "no matching activity" fallback doesn't actually advance to the next
# screen -- it leaves the task parked on OpaWrapper, resumed, indefinitely
# (confirmed live via dumpsys activity top, lemonade). Disabled until that's
# fixed (install Velvet, or patch OpaWrapper) or Google fixes the fallback
# upstream.
TARGET_INCLUDE_PARTNER_SETUP := false
TARGET_INCLUDE_GOOGLE_TELECOMM := true
TARGET_NEEDS_VULKAN_MEDIA_FIX := true

# Convert double-tap-to-wake into an AOD pulse instead of a full wake.
# config_supportDoubleTapWake is already true for this device (see
# device/oneplus/sm8350-common's OPlusFrameworksResCommon overlay).
TARGET_DOZE_DOUBLE_TAP_PULSE_SUPPORTED := true

ifneq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.adb.secure=0 \
    ro.adb.secure.mandatory=0 \
    persist.sys.usb.config=adb \
    persist.sys.ax_debug_enabled=1
endif

# inherit product configs
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

# Inherit from the common OEM chipset makefile.
$(call inherit-product, device/oneplus/sm8350-common/common.mk)

# Inherit from the proprietary files makefile.
$(call inherit-product, vendor/oneplus/lemonadep/lemonadep-vendor.mk)
