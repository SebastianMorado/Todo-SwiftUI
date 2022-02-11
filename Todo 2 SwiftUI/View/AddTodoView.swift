//
//  AddTodoView.swift
//  Todo 2 SwiftUI
//
//  Created by Sebastian Morado on 2/8/22.
//

import SwiftUI

struct AddTodoView: View {
    //MARK: - Property
    @EnvironmentObject var todoManager : TodoManager
    @EnvironmentObject var settingsManager : SettingsManager
    @Environment(\.presentationMode) var presentationMode
    
    @State private var errorShowing: Bool = false
    @State private var errorTitle: String = ""
    @State private var errorMessage: String = ""
    
    //MARK: - Body
    var body: some View {
        NavigationView {
            VStack {
                VStack(alignment: .leading, spacing: 20) {
                    TextField("Todo", text: $todoManager.name)
                        .padding()
                        .background(Color(uiColor: .tertiarySystemFill))
                        .cornerRadius(9)
                        .font(.system(size: 24, weight: .bold, design: .default))
                    Picker("Priority", selection: $todoManager.priority) {
                        ForEach(todoManager.priorities, id: \.self) { priority in
                            Text(priority)
                        }
                    }
                    .pickerStyle(.segmented)
                    .colorMultiply(settingsManager.colorize(priority: todoManager.priority))
                    HStack {
                        Spacer()
                        Button {
                            todoManager.save()
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Text("Save")
                                .font(.system(size: 24, weight: .bold))
                                .padding()
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .foregroundColor(todoManager.name.isEmpty ? .secondary : .white)
                                .background(todoManager.name.isEmpty ? .gray : settingsManager.getCurrentColor())
                                .cornerRadius(9)
                                .animation(.easeOut, value: todoManager.name.isEmpty)
                        }
                        .disabled(todoManager.name.isEmpty)
                        Spacer()
                    }
                } //:VStack
                .padding(.horizontal)
                .padding(.vertical, 30)
                Spacer()
            }//: VSTACK
            .navigationTitle("New Todo")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                        todoManager.clearFields()
                    } label: {
                        Image(systemName: "xmark")
                    }

                }
            }
            .alert("Error", isPresented: $todoManager.isError, actions: {}, message: {
                Text(todoManager.errorMessage)
            })
        } //: Navigation
        .tint(settingsManager.getCurrentColor())
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct AddTodoView_Previews: PreviewProvider {
    
    static var previews: some View {
        let viewContext = PersistenceController.shared.container.viewContext
        AddTodoView()
            .environmentObject(TodoManager(context: viewContext))
            .environmentObject(SettingsManager())
    }
}
