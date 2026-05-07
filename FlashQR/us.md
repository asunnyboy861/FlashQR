# FlashQR - iOS Development Guide

## Executive Summary

FlashQR is a minimalist utility app that solves a universal pain point: displaying QR codes at checkout with automatic screen brightness enhancement. When users need to show a QR code at a store, their screen is often too dim for scanners to read. FlashQR automatically brightens the QR code area, then restores the original brightness when done — no manual adjustment needed.

**Key Differentiators**:
- EDR (Extended Dynamic Range) technology: Only brightens the QR code area, not the entire screen — no system brightness change, no restore bugs
- Triple brightness restore guarantee: Timer + lifecycle + manual button
- One-time purchase at $1.99 vs competitors' $14.99 or monthly subscriptions
- Free tier with no ads — builds trust and drives Pro conversions

**Target Audience**: US smartphone users who regularly show QR codes, barcodes, or loyalty cards at checkout (estimated 80%+ of iPhone users)

**Category**: Utilities

## Competitive Analysis

| App | Rating | Price | Brightness Feature | Key Weakness | Our Advantage |
|-----|--------|-------|-------------------|--------------|---------------|
| Barcodes (Small Colossus) | 4.8 | Free + IAP (lifetime ~$14.99 or subscription) | "Light up your screen" | 3 free card limit; expensive unlock; full-screen brightness only | EDR local highlight; $1.99 one-time; no subscription |
| KeepCard | 4.8 | Free + IAP ($0.98/mo or ~$70 lifetime) | "Brighter, larger barcode" | Ads in free version; crude brightness control | No ads ever; EDR technology; reliable brightness restore |
| Discount Card Wallet | 4.8 | Free + IAP | "Maximize Brightness" | Full-screen brightness; no auto-restore | EDR local highlight; triple restore guarantee |
| iOS Wallet | 4.7 | Free | Auto-brightness for PassKit | Only supports official PassKit format; known brightness restore bug | Supports any QR/barcode image; reliable restore |
| Barcode Wallet | New | Free | None | No brightness feature at all | Core brightness feature built-in |

## Apple Design Guidelines Compliance

- **HIG - Utilities**: App follows minimalist utility design — opens directly to card list, one-tap to display
- **HIG - Dark Mode**: Dark mode as default for maximum QR code contrast
- **HIG - Accessibility**: VoiceOver labels on all interactive elements; Dynamic Type support
- **HIG - Gestures**: Swipe to delete cards; tap to display; pull down to dismiss
- **HIG - Navigation**: Simple flat navigation — card list → full-screen display → back
- **App Store Review 3.1.1**: IAP one-time purchase (non-consumable) for Pro upgrade; no subscription traps
- **App Store Review 5.1.1**: No data collection; privacy-first approach; all data stored locally

## Technical Architecture

- **Language**: Swift 5.9+
- **Framework**: SwiftUI (primary), MetalKit (EDR rendering), UIKit (MTKView wrapper only)
- **Data**: SwiftData (iOS 17+) for card storage; UserDefaults for settings
- **QR Generation**: dagronf/QRCode (MIT License, SPM)
- **EDR Rendering**: Metal + CIImage (based on mszpro/QR-Code-EDR, MIT License)
- **Image Detection**: Vision framework (VNDetectBarcodesRequest)
- **Networking**: None — fully offline, no server, no tracking
- **Concurrency**: async/await + Actor pattern
- **Minimum iOS**: 17.0 (SwiftData requirement)

## Module Structure

```
FlashQR/
├── FlashQRApp.swift
├── Views/
│   ├── Main/
│   │   ├── CardListView.swift
│   │   └── OnboardingView.swift
│   ├── Display/
│   │   ├── QRDisplayView.swift
│   │   └── EDRQRCodeView.swift
│   ├── AddCard/
│   │   ├── AddCardView.swift
│   │   ├── CameraScanView.swift
│   │   └── PhotoPickerView.swift
│   ├── Settings/
│   │   ├── SettingsView.swift
│   │   └── ContactSupportView.swift
│   └── Components/
│       ├── CardRowView.swift
│       └── TimerProgressView.swift
├── ViewModels/
│   ├── CardListViewModel.swift
│   ├── QRDisplayViewModel.swift
│   └── AddCardViewModel.swift
├── Models/
│   ├── QRCard.swift
│   └── AppSettings.swift
├── Services/
│   ├── BrightnessManager.swift
│   ├── EDRRenderer.swift
│   ├── QRCodeGenerator.swift
│   ├── PhotoQRImporter.swift
│   └── PurchaseManager.swift
└── Extensions/
    ├── Color+Hex.swift
    └── View+Modifiers.swift
```

## Implementation Flow

1. Set up project structure, SPM dependencies (dagronf/QRCode), Info.plist (Camera, Photo Library)
2. Implement SwiftData models (QRCard, AppSettings)
3. Build BrightnessManager with triple restore guarantee
4. Build EDRRenderer (Metal + CIImage) with fallback to traditional brightness
5. Build QRDisplayView with EDR/traditional/auto mode selection
6. Build CardListView with card CRUD operations
7. Build AddCardView with camera scan, photo import, manual entry
8. Build PhotoQRImporter using Vision framework
9. Build QRCodeGenerator using dagronf/QRCode library
10. Implement PurchaseManager with StoreKit 2 (non-consumable IAP)
11. Build SettingsView with policy page links and restore purchases
12. Build OnboardingView for first-time users
13. Build ContactSupportView with feedback backend integration
14. Generate app icon using Wanxiang Image API
15. Build and test on iPhone and iPad simulators

## UI/UX Design Specifications

- **Color Scheme (Dark Mode Default)**:
  - Background: #000000 (pure black, OLED-friendly)
  - Card background: #1C1C1E (iOS system dark gray)
  - Primary accent: #0A84FF (iOS system blue)
  - QR code background: #FFFFFF (pure white, max contrast)
  - QR code foreground: #000000 (pure black, max contrast)
  - Success: #30D158, Warning: #FF9F0A, Danger: #FF453A

- **Color Scheme (Light Mode)**:
  - Background: #F2F2F7 (iOS system light gray)
  - Card background: #FFFFFF
  - Primary accent: #007AFF

- **Typography**: SF Pro (system default); large title for navigation; body for content
- **Layout**: Card-based list; full-screen immersive QR display; max-width 720 for iPad content
- **Animations**: Spring transitions for card taps (0.3s); ease-in-out for QR appearance (0.4s); ease-out for brightness restore (0.5s)

## Code Generation Rules

- SwiftUI only (except MTKView UIKit wrapper for Metal)
- SwiftData for all persistent data
- All SwiftData attributes must be optional or have default values
- All SwiftData relationships must have inverse relationships
- No third-party analytics or tracking
- No network requests — fully offline
- VoiceOver and Dynamic Type support on all views
- iPad layout: .frame(maxWidth: 720).frame(maxWidth: .infinity) for ScrollView content
- Never use .tabViewStyle(.sidebarAdaptable)
- No code comments unless explicitly requested

## Build & Deployment Checklist

- [ ] Build succeeds on iPhone simulator
- [ ] Build succeeds on iPad simulator
- [ ] App launches and displays card list
- [ ] QR code display with EDR/traditional mode works
- [ ] Brightness restore works (timer + lifecycle + manual)
- [ ] Camera scan imports QR code
- [ ] Photo library import works
- [ ] Manual entry works
- [ ] IAP purchase flow works
- [ ] Settings page with policy links works
- [ ] Contact support sends feedback
- [ ] No secrets in source code
- [ ] Push to GitHub repository
- [ ] Deploy policy pages to GitHub Pages
