# Capabilities Configuration

## Analysis

Based on operation guide analysis, the following capabilities are required:

- Camera access: App needs camera to scan QR codes ("相机", "扫描", "camera", "scan")
- Photo Library access: App imports QR codes from photos ("相册", "照片", "photo", "import")
- In-App Purchase: App offers Pro upgrade as one-time purchase ("购买", "买断", "Pro", "premium")

## Auto-Configured Capabilities

| Capability | Status | Method |
|------------|--------|--------|
| Camera Usage (NSCameraUsageDescription) | ✅ Configured | Info.plist key |
| Photo Library Usage (NSPhotoLibraryUsageDescription) | ✅ Configured | Info.plist key |
| In-App Purchase | ✅ Configured | Xcode capability |

## Manual Configuration Required

| Capability | Status | Steps |
|------------|--------|-------|
| In-App Purchase (App Store Connect) | ⏳ Pending | 1. Create app record in App Store Connect 2. Create non-consumable IAP product: com.zzoutuo.FlashQR.pro 3. Set price to $1.99 4. Submit for review alongside app |

## No Configuration Needed

- Push Notifications: Not required (no notifications)
- iCloud/CloudKit: Not required for MVP (local storage only)
- HealthKit: Not applicable
- Location Services: Not required
- Apple Watch: Deferred to future version
- WidgetKit: Deferred to future version
- Background Modes: Not required
- Siri: Not required
- Sign in with Apple: Not required

## Required Info.plist Keys

| Key | Value |
|-----|-------|
| NSCameraUsageDescription | "FlashQR needs camera access to scan QR codes and barcodes" |
| NSPhotoLibraryUsageDescription | "FlashQR needs photo library access to import QR codes from your photos" |

## Verification

- Build succeeded after configuration: ✅ Verified
- All entitlements correct: ✅ Verified
