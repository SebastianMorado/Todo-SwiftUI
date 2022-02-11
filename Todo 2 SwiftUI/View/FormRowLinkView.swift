//
//  FormRowLinkView.swift
//  Todo 2 SwiftUI
//
//  Created by Sebastian Morado on 2/11/22.
//

import SwiftUI

struct FormRowLinkView: View {
    //MARK: - Property
    var icon: String
    var color: Color
    var text: String
    var link: String
    
    @EnvironmentObject var settingsManager : SettingsManager
    
    //MARK: - Body
    var body: some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(color)
                Image(systemName: icon)
                    .imageScale(.large)
                    .foregroundColor(.white)
            }
            .frame(width: 36, height: 36, alignment: .center)
            
            Text(text)
                .foregroundColor(.gray)
            
            Spacer()
            
            Button {
                settingsManager.openURL(link: link)
            } label: {
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .tint(Color(.systemGray2))
            }

        }
    }
}

struct FormRowLinkView_Previews: PreviewProvider {
    static var previews: some View {
        FormRowLinkView(icon: "globe", color: Color.pink, text: "Website", link: "https://google.com")
            .previewLayout(.fixed(width: 375, height: 60))
            .padding()
            .environmentObject(SettingsManager())
    }
}
