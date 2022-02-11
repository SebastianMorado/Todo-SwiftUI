//
//  SettingsManager.swift
//  Todo 2 SwiftUI
//
//  Created by Sebastian Morado on 2/11/22.
//

import Foundation
import SwiftUI

class SettingsManager: ObservableObject {
    
    
    //MARK: - Setting and Updating app icon
    var iconNames: [String?] = [nil]
    @Published var currentIndex = 0
    
    init() {
        currentTheme = UserDefaults.standard.string(forKey: "Theme") ?? "Pink"
        
        getAlternateIconNames()
        if let currentIcon = UIApplication.shared.alternateIconName {
            self.currentIndex = iconNames.firstIndex(of: currentIcon) ?? 0
        }
        
        
    }
    
    func getAlternateIconNames() {
        if let icons = Bundle.main.object(forInfoDictionaryKey: "CFBundleIcons") as? [String: Any],
           let alternateIcons = icons["CFBundleAlternateIcons"] as? [String: Any] {
            for (_, value) in alternateIcons {
                guard let iconList = value as? Dictionary<String, Any> else { return }
                guard let iconFiles = iconList["CFBundleIconFiles"] as? [String] else {return}
                guard let icon = iconFiles.first else {return}
                
                iconNames.append(icon)
            }
        }
    }
    
    func updateIcon(at value: Int) {
        let index = iconNames.firstIndex(of: UIApplication.shared.alternateIconName) ?? 0
        if index != value {
            UIApplication.shared.setAlternateIconName(iconNames[value]) { error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    print("success")
                }
            }
        }
    }
    
    //MARK: - Opening Links
    
    func openURL(link : String) {
        guard let url = URL(string: link), UIApplication.shared.canOpenURL(url) else {
            return
        }
        UIApplication.shared.open(url as URL)
    }
    
    //MARK: - Choosing Themes
    
    @Published var currentTheme : String
    let themes : [String] = [
        "Pink",
        "Blue",
        "Green"
    ]
    
    func getCurrentColor() -> Color {
        if currentTheme == "Pink" {
            return Color.pink
        } else if currentTheme == "Blue" {
            return Color.blue
        } else {
            return Color.green
        }
    }
    
    func saveSettings() {
        UserDefaults.standard.set(currentTheme, forKey: "Theme")
    }
    
    func colorize(priority: String?) -> Color {
        switch priority {
        case "High":
            return .red
        case "Normal":
            return .orange
        case "Low":
            return .yellow
        default:
            return .yellow
        }
        
    }
    
}
