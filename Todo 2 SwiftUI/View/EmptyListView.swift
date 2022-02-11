//
//  EmptyListView.swift
//  Todo 2 SwiftUI
//
//  Created by Sebastian Morado on 2/11/22.
//

import SwiftUI

struct EmptyListView: View {
    //MARK: - Property
    @EnvironmentObject var settingsManager : SettingsManager
    @State private var isAnimating : Bool = false
    
    let tips: [String] = [
        "Use your time wisely.",
        "Slow and steady wins the race",
        "Keep it short and sweet.",
        "Put hard tasks first.",
        "Reward yourself after work.",
        "Collect tasks ahead of time.",
        "Each night schedule for tomorrow"
    ]
    
    //MARK: - Body
    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 20) {
                Image("illustration-no\(Int.random(in: 1...3))")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(minWidth: 256, idealWidth: 280, maxWidth: 360, minHeight: 256, idealHeight: 280, maxHeight: 360, alignment: .center)
                    .layoutPriority(1)
                    .foregroundColor(settingsManager.getCurrentColor())
                Text(tips.randomElement()!)
                    .foregroundColor(settingsManager.getCurrentColor())
                    .layoutPriority(0.5)
                    .font(.system(.headline, design: .rounded))
            }
            .padding(.horizontal)
            .opacity(isAnimating ? 1 : 0)
            .offset(x: 0, y: isAnimating ? 0 : -50)
            .animation(.easeOut(duration: 1.5), value: isAnimating)
            .onAppear {
                isAnimating = true
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(Color("ColorBase"))
        .edgesIgnoringSafeArea(.all)
    }
}

struct EmptyListView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyListView()
            .preferredColorScheme(.dark)
            .environmentObject(SettingsManager())
    }
}
