# Git Repositories

## Main App (iOS Application)

| Item | Value |
|------|-------|
| **Repository Name** | FlashQR |
| **Git URL** | git@github.com:asunnyboy861/FlashQR.git |
| **Repo URL** | https://github.com/asunnyboy861/FlashQR |
| **Visibility** | Public |
| **Primary Language** | Swift |
| **GitHub Pages** | ✅ **ENABLED** (from `/docs` folder) |

## Policy Pages (Deployed from Main Repository /docs)

| Page | URL | Status |
|------|-----|--------|
| Landing Page | https://asunnyboy861.github.io/FlashQR/ | ✅ Active |
| Support | https://asunnyboy861.github.io/FlashQR/support.html | ✅ Active |
| Privacy Policy | https://asunnyboy861.github.io/FlashQR/privacy.html | ✅ Active |

**Note**: Terms of Use not required for Free/Paid Download apps.

## Repository Structure

```
FlashQR/
├── FlashQR/                       # iOS App Source Code
│   ├── FlashQR.xcodeproj/         # Xcode Project
│   ├── FlashQR/                   # Swift Source Files
│   │   ├── Views/
│   │   ├── Models/
│   │   ├── Services/
│   │   └── ...
│   └── ...
├── docs/                          # Policy Pages (GitHub Pages source)
│   ├── index.html                 # Landing Page
│   ├── support.html               # Support Page
│   └── privacy.html               # Privacy Policy
├── .github/workflows/
│   └── deploy.yml                 # GitHub Pages deployment
├── us.md                          # English Development Guide
├── keytext.md                     # App Store Metadata
├── capabilities.md                # Capabilities Configuration
├── icon.md                        # App Icon Details
├── price.md                       # Pricing Configuration
└── nowgit.md                      # This File
```
