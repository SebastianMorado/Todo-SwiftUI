//
//  CheckboxStyle.swift
//  Todo 2 SwiftUI
//
//  Created by Sebastian Morado on 2/12/22.
//

import SwiftUI

struct CheckboxStyle: ToggleStyle {
    @EnvironmentObject var settingsManager : SettingsManager
    
    func makeBody(configuration: Configuration) -> some View {
        return HStack {
            Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
                .foregroundColor(configuration.isOn ? settingsManager.getCurrentColor() : .primary)
                .font(.system(size: 20, weight: .semibold, design: .rounded))
                .onTapGesture {
                    configuration.isOn.toggle()
                }
        }
    }
}

struct CheckboxStyle_Previews: PreviewProvider {
    static var previews: some View {
        Toggle("Placeholder Label", isOn: .constant(false))
            .toggleStyle(CheckboxStyle())
            .padding()
            .previewLayout(.sizeThatFits)
            .environmentObject(SettingsManager())
    }
}
