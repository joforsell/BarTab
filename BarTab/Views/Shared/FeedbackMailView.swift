//
//  FeedbackMailView.swift
//  BarTab
//
//  Created by Johan Forsell on 2022-03-27.
//

import SwiftUI
import SwiftUIX

struct FeedbackMailView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass

    @EnvironmentObject var avoider: KeyboardAvoider
    
    @State private var subject = ""
    @State private var editingSubject = false
    @State private var message = ""
    @State private var returnAddress = ""
    @State private var editingReturnAddress = false
    @State private var isShowingAlert = false
    @State private var feedbackToast = false
    
    @FocusState private var isMessageFocused: Bool
    
    init() {
        UITextView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 20) {
                KeyboardAvoiding(with: avoider) {
                    Image(systemName: "envelope.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.accentColor)
                        .font(.system(size: 160, weight: .thin))
                        .padding(.bottom, 48)
                        .padding(.top, 24)
                        .frame(maxWidth: geometry.size.width/2, maxHeight: geometry.size.height/2)
                
                    CustomInputView(title: "Subject",
                                    image: "textformat",
                                    editing: $editingSubject,
                                    text: $subject,
                                    keyboardTag: 1)
                    
                    TextEditor(text: $message)
                        .focused($isMessageFocused)
                        .frame(width: 300)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(6)
                        .addBorder(isMessageFocused ? .accentColor : Color.clear, width: 1, cornerRadius: 6)
                        .animation(.easeInOut, value: isMessageFocused)
                        .autocapitalization(.sentences)
                        .disableAutocorrection(true)
                        .onChange(of: isMessageFocused, perform: { focus in
                            if focus {
                                self.avoider.editingField = 2
                            }
                        })
                        .avoidKeyboard(tag: 2)
                        .overlay(alignment: .topTrailing) {
                            Image(systemName: "text.quote")
                                .resizable()
                                .scaledToFit()
                                .opacity(0.5)
                                .frame(height: 30)
                                .offset(x: -18, y: 12)
                        }
                        .overlay(alignment: .topLeading) {
                            Text("Feedback")
                                .font(.caption2)
                                .textCase(.uppercase)
                                .foregroundColor(.white)
                                .opacity(0.5)
                                .offset(x: 16, y: 8)
                        }

                    
                    CustomInputView(title: "Reply to",
                                    image: "envelope",
                                    editing: $editingReturnAddress,
                                    text: $returnAddress,
                                    keyboardTag: 3)
                }
                
                Color.clear
                    .frame(width: 300, height: 16)
                    .padding()
                    .overlay {
                        HStack {
                            Button {
                                withAnimation {
                                    presentationMode.wrappedValue.dismiss()
                                }
                            } label: {
                                VisualEffectBlurView(blurStyle: .dark)
                                    .addBorder(Color.accentColor, width: 1, cornerRadius: 6)
                                    .overlay {
                                        Text("Cancel")
                                            .foregroundColor(.accentColor)
                                            .fontWeight(.bold)
                                            .textCase(.uppercase)
                                    }
                            }
                            Button {
                                if subject.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                    isShowingAlert = true
                                } else {
                                    EmailSender.sendFeedback(subject: subject, message: message, returnAddress: returnAddress)
                                    feedbackToast = true
                                }
                            } label: {
                                RoundedRectangle(cornerRadius: 6)
                                    .overlay {
                                        Text("Send feedback")
                                            .foregroundColor(.white)
                                            .fontWeight(.bold)
                                            .textCase(.uppercase)
                                    }
                            }
                            .toast(isPresented: $feedbackToast, dismissAfter: 3, onDismiss: {
                                feedbackToast = false
                                withAnimation {
                                    presentationMode.wrappedValue.dismiss()
                                }
                            }) {
                                ToastView(systemImage: ("envelope.fill", .accentColor, 50), title: "E-mail sent", subTitle: "Thank you for your feedback!")
                            }
                        }
                        .alert(isPresented: $isShowingAlert) {
                            Alert(title: Text("Subject nor message cannot be left empty."), dismissButton: .default(Text("OK")))
                        }
                    }
                Spacer()
            }
            .center(.horizontal)
        }
        .background(VisualEffectBlurView(blurStyle: .dark))
    }
}
