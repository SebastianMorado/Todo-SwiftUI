//
//  MainView.swift
//  Todo 2 SwiftUI
//
//  Created by Sebastian Morado on 2/8/22.
//

import SwiftUI

struct MainView: View {
    //MARK: - property
    @ObservedObject var todoManager : TodoManager
    @EnvironmentObject var settingsManager : SettingsManager
    @State private var isShowingAddTodoView : Bool = false
    @State private var isShowingSettingsView : Bool = false
    
    init(todoManager: TodoManager) {
        UITextView.appearance().backgroundColor = .clear
        self.todoManager = todoManager
    }
    
    
    //MARK: - Body
    var body: some View {
        NavigationView {
            ZStack {
                List() {
                    ForEach($todoManager.todoItems) {$item in
                        HStack{
                            TextEditor(text: $item.name ?? "No Name")
                            .onChange(of: item.name, perform: { newValue in
                                todoManager.updateItem(todo: item)
                            })
                            .font(.system(size: 20, weight: .semibold, design: .default))
                            .multilineTextAlignment(.leading)
                            .lineLimit(nil)
                            Text(item.priority!)
                                .font(.footnote)
                                .fontWeight(.bold)
                                .foregroundColor(Color(uiColor: UIColor.secondarySystemBackground))
                                .padding(3)
                                .frame(minWidth: 62)
                                .background(
                                    Capsule()
                                        .fill(settingsManager.colorize(priority: item.priority))
                                )
                            
                        }
                        .padding(.horizontal)
                    }
                    .onDelete { offsets in
                        todoManager.deleteItem(at: offsets)
                    }
                } //: List
                .navigationTitle("Todo")
                .navigationBarTitleDisplayMode(.large)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            isShowingSettingsView.toggle()
                        } label: {
                            Image(systemName: "paintbrush")
                        } //: Add Button
                        .sheet(isPresented: $isShowingSettingsView) {
                            SettingsView()
                        }
                        .tint(settingsManager.getCurrentColor())

                    }
                }
                
                //MARK: - No Todo Items
                if todoManager.todoItems.count == 0 {
                    EmptyListView()
                }
                
            } //: ZStack
            .sheet(isPresented: $isShowingAddTodoView) {
                AddTodoView()
            }
            .overlay(
                ZStack {
                    Group {
                        Circle()
                            .fill(settingsManager.getCurrentColor())
                            .opacity(0.2)
                            .frame(width: 68, height: 68, alignment: .center)
                        Circle()
                            .fill(settingsManager.getCurrentColor())
                            .opacity(0.15)
                            .frame(width: 88, height: 88, alignment: .center)

                    }
                    .padding(.bottom, 15)
                    .padding(.trailing, 15)
                    
                    Button(action: {
                        isShowingAddTodoView.toggle()
                    }, label: {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .background(Circle().fill(Color("ColorBase")))
                            .frame(width: 48, height: 48, alignment: .center)
                            .tint(settingsManager.getCurrentColor())
                    })
                    .padding(.bottom, 15)
                    .padding(.trailing, 15)
                } //: Zstack
                ,alignment: .bottomTrailing
            )
            
        } //: Navigation
        .alert("Error", isPresented: $todoManager.isError, actions: {}, message: {
            Text(todoManager.errorMessage)
        })
        .environmentObject(todoManager)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext = PersistenceController.shared.container.viewContext
        MainView(todoManager: TodoManager(context: viewContext))
            .environmentObject(SettingsManager())
    }
}
