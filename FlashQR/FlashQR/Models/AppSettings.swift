import Foundation

enum DisplayMode: String, CaseIterable, Codable {
    case edr = "EDR"
    case traditional = "Traditional"
    case auto = "Auto"
}

@Observable
final class AppSettings {
    var autoRestoreInterval: Double {
        didSet { UserDefaults.standard.set(autoRestoreInterval, forKey: "autoRestoreInterval") }
    }
    var displayMode: DisplayMode {
        didSet { UserDefaults.standard.set(displayMode.rawValue, forKey: "displayMode") }
    }
    var hasCompletedOnboarding: Bool {
        didSet { UserDefaults.standard.set(hasCompletedOnboarding, forKey: "hasCompletedOnboarding") }
    }

    init() {
        self.autoRestoreInterval = UserDefaults.standard.object(forKey: "autoRestoreInterval") as? Double ?? 120.0
        self.displayMode = DisplayMode(rawValue: UserDefaults.standard.string(forKey: "displayMode") ?? "") ?? .auto
        self.hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
    }
}
