# LineageOS 23.0 Device Tree — Xiaomi Redmi Pad Pro 5G / POCO Pad 5G (ruan)

> **Status:** Work in Progress — Unofficial
              Recovery boots by live booting for now
              Rom - Bootloops (tbh idk why)

---

## Device Info

| Property | Value |
|---|---|
| Device | Xiaomi Redmi Pad Pro 5G/ POCO Pad pro 5G|
| Codename | `dizi` (WiFi) / `ruan` (5G) |
| SoC | Snapdragon 7s Gen 2 (SM7435P / Parrot) |
| Architecture | ARM64 |
| Display | 12.1" 1600×2560 @ 120Hz |
| RAM | 6GB / 8GB / 12GB |
| Storage | 128GB / 256GB / 512GB (UFS) |
| Battery | 10000 mAh |
| Charging | 33W wired |
| Cameras | 8MP front, 8MP rear (OV08D10), 13MP (OV13B10) |
| WiFi | WCN6750 (QCA6750) |
| Bluetooth | 5.3 |
| NFC | No |
| Fingerprint | No |

---

## Branches

| Branch | Purpose |
|---|---|
| `lineage-23.0-ruan` | Device tree |
| `vendor` | Vendor blobs connected to other branches by setup |

---

## Build Instructions

```bash
# 1. Repo sync
repo sync -c -j16 --force-sync --no-clone-bundle --no-tags

# 2. Run the setup.sh 
bash setup.sh

# 3. Build
source build/envsetup.sh
breakfast ruan
mka bacon
```

---

## Partition Sizes (from stock ROM — SM7435P)

| Partition | Size |
|---|---|
| boot | 100663296 (96MB) |
| recovery | 104857600 (100MB) |
| vendor_boot | 100663296 (96MB) |
| dtbo | 25165824 (24MB) |

---

## Key Differences vs Garnet (base device)

| Feature | Garnet | Ruan |
|---|---|---|
| WiFi/BT | WCN3990 (Adrastea) | WCN6750 (QCA6750) |
| Cameras | 4 sensors | 3 sensors (GC08A3, OV08D10, OV13B10) |
| Display | 6.67" 480 DPI | 12.1" 280 DPI |
| Fingerprint | Side-mounted | None |
| NFC | Yes | No |
| Board ID | `0x1000b 0x00` | `0x2000b 0x01` |

---

## Flashing Instructions

1. Flash recovery: `fastboot flash recovery recovery.img`
2. Reboot to recovery: `fastboot reboot recovery`
3. Factory Reset → Format Data (type "yes") — **REQUIRED**
4. Apply Update → ADB Sideload
5. `adb sideload lineage-23.0-*-ruan.zip`

> If stuck at metadata: `fastboot erase metadata` then reboot recovery.

---

## Credits

- [garnet-random](https://github.com/garnet-random) — kernel source and base device tree (Redmi Note 13 Pro)
- [M0Rf30](https://github.com/M0Rf30) for the initial-tree and hardware references
- [LineageOS](https://github.com/LineageOS) — Android base
- Ported to dizi/ruan by [nobleactual17](https://github.com/nobleactual17)
[noble6](https://github.com/noble6) 
And to all other my testers and supporters
