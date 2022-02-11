//
//  SettingsView.swift
//  Todo 2 SwiftUI
//
//  Created by Sebastian Morado on 2/11/22.
//

import SwiftUI

struct SettingsView: View {
    //MARK: - Property
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var settingsManager : SettingsManager
    
    //MARK: - Body
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    //MARK: - Section 1
                    Section {
                        Picker(selection: $settingsManager.currentIndex) {
                            ForEach(0..<settingsManager.iconNames.count) { index in
                                HStack {
                                    Image(uiImage: UIImage(named: settingsManager.iconNames[index] ?? "Blue") ?? UIImage())
                                        .renderingMode(.original)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 44, height: 44, alignment: .center)
                                        .cornerRadius(9)
                                    Spacer().frame(width: 10)
                                    Text(settingsManager.iconNames[index] ?? "Blue")
                                        .frame(alignment: .leading)
                                }
                                .padding(3)
                            }
                        } label: {
                            HStack {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 9,style: .continuous)
                                        .strokeBorder(.primary, lineWidth: 2)
                                    Image(systemName: "paintbrush")
                                        .font(.system(size: 28, weight: .regular))
                                        .foregroundColor(.primary)
                                    
                                }
                                .frame(width: 44, height: 44, alignment: .center)
                                Text("App Icon".uppercased())
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.primary)
                            }
                        }
                        .onReceive([settingsManager.currentIndex].publisher.first()) { value in
                            settingsManager.updateIcon(at: value)
                        }

                    } header: {
                        Text("Choose the app icon")
                    }
                    
                    //MARK: - Section 2
                    Section {
                        Picker("Theme", selection: $settingsManager.currentTheme) {
                            ForEach(settingsManager.themes, id:\.self) {theme in
                                Text(theme)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .colorMultiply(settingsManager.getCurrentColor())
                        .onChange(of: settingsManager.currentTheme) { value in
                            settingsManager.saveSettings()
                        }
                    
                    } header: {
                        HStack {
                            Text("Choose the app theme")
                            Circle()
                                .fill(settingsManager.getCurrentColor())
                                .frame(width: 15, height: 15, alignment: .center)
                        }
                    }
                    
                    //MARK: - Section 3
                    
                    Section {
                        FormRowLinkView(icon: "globe", color: Color.pink, text: "Website", link: "https://swiftuimasterclass.com")
                        FormRowLinkView(icon: "link", color: Color.cyan, text: "Twitter", link: "https://twitter.com/shmorado")
                        FormRowLinkView(icon: "play.rectangle", color: Color.blue, text: "Facebook", link: "https://facebook.com/sebastian.hernandez.morado")
                    } header: {
                        Text("Follow us on social media")
                    }
                    
                    //MARK: - Section 4
                    Section {
                        FormRowStaticView(icon: "gear", firstText: "Application", secondText: "Todo")
                        FormRowStaticView(icon: "checkmark.seal", firstText: "Compatibility", secondText: "iPhone, iPad")
                        FormRowStaticView(icon: "keyboard", firstText: "Developer", secondText: "Sebastian Morado")
                        FormRowStaticView(icon: "paintbrush", firstText: "Designer", secondText: "Robert Petras")
                        FormRowStaticView(icon: "flag", firstText: "Version", secondText: "1.0.0")
                    } header: {
                        Text("About the application")
                    }

                } //: Form
                .listStyle(GroupedListStyle())
                .environment(\.horizontalSizeClass, .regular)
                
                //MARK: - Footer
                Text("Copyright © All rights reserved.")
                    .padding(8)
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .background(Color("ColorBackground").edgesIgnoringSafeArea(.all))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }

                }
            }
        }
        .tint(settingsManager.getCurrentColor())
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(SettingsManager())
    }
}
