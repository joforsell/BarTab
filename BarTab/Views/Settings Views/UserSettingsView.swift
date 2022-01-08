//
//  UserSettingsView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-12-06.
//

import SwiftUI
import FirebaseAuth

struct UserSettingsView: View {
    @EnvironmentObject var userHandler: UserHandling
    
    @State private var editingAssociation = false
    @State private var editingEmail = false
    
    @State private var showError = false
    @State private var errorString = ""
    
    var body: some View {
        HStack {
            Spacer()
            VStack(alignment: .center, spacing: 20) {
                Spacer()
                
                Image("bartender")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .foregroundColor(.accentColor)
                    .offset(x: -20)
                
                VStack(alignment: .leading, spacing: 2) {
                    HStack(alignment: .bottom) {
                        TextField("",
                                  text: $userHandler.user.email,
                                  onEditingChanged: { editingChanged in
                            if editingChanged {
                                withAnimation {
                                    editingEmail = true
                                }
                            } else {
                                withAnimation {
                                    editingEmail = false
                                }
                            } },
                                  onCommit: {
                            withAnimation {
                                editingEmail.toggle()
                            }
                            userHandler.updateUserEmail(userHandler.user.email ?? "")
                        }
                        )
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .font(.title3)
                        Spacer()
                    }
                    .offset(y: 4)
                    .overlay(alignment: .trailing) {
                        Image(systemName: editingEmail ? "checkmark.rectangle.fill" : "envelope.fill")
                            .resizable()
                            .scaledToFit()
                            .opacity(editingEmail ? 1 : 0.5)
                            .foregroundColor(editingEmail ? .accentColor : .white)
                            .onTapGesture {
                                editingEmail ? userHandler.updateUserEmail(userHandler.user.email ?? "") : nil
                                UIApplication.shared.sendAction(#selector(UIApplication.resignFirstResponder), to: nil, from: nil, for: nil)
                            }
                    }
                    .overlay(alignment: .topLeading) {
                        Text("Email".uppercased())
                            .font(.caption2)
                            .foregroundColor(.white)
                            .opacity(0.5)
                            .offset(y: -10)
                    }
                }
                .frame(width: 300, height: 24)
                .padding()
                .foregroundColor(.white)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(6)
                .addBorder(editingEmail ? .accentColor : Color.clear, width: 1, cornerRadius: 6)
                .padding(.top, 48)
                
                VStack(alignment: .leading, spacing: 2) {
                    HStack(alignment: .bottom) {
                        TextField("",
                                  text: $userHandler.user.association,
                                  onEditingChanged: { editingChanged in
                            if editingChanged {
                                withAnimation {
                                    editingAssociation = true
                                }
                            } else {
                                withAnimation {
                                    editingAssociation = false
                                }
                            } },
                                  onCommit: {
                            withAnimation {
                                editingAssociation.toggle()
                            }
                            userHandler.updateUserAssociation(userHandler.user.association ?? "")
                        }
                        )
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .font(.title3)
                        Spacer()
                    }
                    .offset(y: 4)
                    .overlay(alignment: .trailing) {
                        Image(systemName: editingAssociation ? "checkmark.rectangle.fill" : "suitcase.fill")
                            .resizable()
                            .scaledToFit()
                            .opacity(editingAssociation ? 1 : 0.5)
                            .foregroundColor(editingAssociation ? .accentColor : .white)
                            .onTapGesture {
                                editingAssociation ? userHandler.updateUserAssociation(userHandler.user.association ?? "") : nil
                                UIApplication.shared.sendAction(#selector(UIApplication.resignFirstResponder), to: nil, from: nil, for: nil)
                            }

                    }
                    .overlay(alignment: .topLeading) {
                        Text("Association".uppercased())
                            .font(.caption2)
                            .foregroundColor(.white)
                            .opacity(0.5)
                            .offset(y: -10)
                    }
                }
                .frame(width: 300, height: 24)
                .padding()
                .foregroundColor(.white)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(6)
                .addBorder(editingAssociation ? .accentColor : Color.clear, width: 1, cornerRadius: 6)
                
                Toggle("Använd RFID-brickor", isOn: $userHandler.user.usingTags)
                    .toggleStyle(SwitchToggleStyle(tint: .accentColor))
                    .frame(width: 300, height: 24)
                    .foregroundColor(.white)
                    .onChange(of: userHandler.user.usingTags) { usingTags in
                        userHandler.updateUserTagUsage(usingTags)
                    }
                
                Picker("Drycker per rad", selection: $userHandler.user.drinkCardColumns) {
                    Text("2").tag(2)
                    Text("3").tag(3)
                    Text("4").tag(4)
                    Text("5").tag(5)
                    Text("6").tag(6)
                }
                .frame(width: 320)
                .pickerStyle(SegmentedPickerStyle())
                .foregroundColor(.accentColor)
                .onChange(of: userHandler.user.drinkCardColumns, perform: { columnCount in
                    userHandler.updateColumnCount(columnCount)
                })
                .overlay(alignment: .topLeading) {
                    Text("Drycker per rad".uppercased())
                        .font(.caption2)
                        .foregroundColor(.white)
                        .opacity(0.5)
                        .offset(x: 10, y: -14)
                }

                Spacer()
            }
            Spacer()
        }
    }
}


