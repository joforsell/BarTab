//
//  CustomerSettingsDetailsView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-12-06.
//

import SwiftUI
import Combine
import Introspect

struct CustomerSettingsDetailView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    @EnvironmentObject var customerListVM: CustomerListViewModel
    @EnvironmentObject var avoider: KeyboardAvoider
    @EnvironmentObject var userHandler: UserHandling
    
    @Binding var customerVM: CustomerViewModel
    @Binding var detailsViewShown: DetailViewRouter
    
    @State var isShowingImageAlternatives = false
    @State var isShowingCameraPicker = false
    @State var image: Image?
    @State var isCamera = false
    
    @State private var editingName = false
    @State private var editingEmail = false
    @State private var editingBalance = false
    
    @State private var isShowingKeyField = false
    @State private var newKey = ""
    @State private var balanceAdjustment = ""
    @State private var addingToBalance = true
    
    @State var adjustingBalance = false
    
    @State private var showError = false
    @State var error: UploadError?
    
    var body: some View {
        HStack {
            Spacer()
            VStack(alignment: .center, spacing: 16) {
                Spacer()
                
                if let image = image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .scaleEffect(0.7)
                        .foregroundColor(.white)
                        .frame(maxHeight: 200)
                        .clipShape(Circle())
                        .overlay {
                            Circle()
                                .stroke(Color.white, lineWidth: 1)
                        }
                        .overlay(alignment: .bottom) {
                            Button {
                                isShowingImageAlternatives = true
                            } label: {
                                Image(systemName: "camera.on.rectangle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30)
                                    .foregroundColor(.accentColor)
                            }
                            .offset(x: 100)
                        }
                        .fullScreenCover(isPresented: $isShowingCameraPicker) {
                            ImagePickerHostView(customer: customerVM.customer, isShown: $isShowingCameraPicker, error: $error, image: $image, isCamera: isCamera)
                        }
                } else {
                    CacheableAsyncImage(url: $customerVM.profilePictureUrl, animation: .easeInOut, transition: .move(edge: .trailing)) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(width: 200, height: 200)
                                .clipShape(Circle())
                                .overlay {
                                    Circle()
                                        .stroke(Color.white, lineWidth: 1)
                                }
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .foregroundColor(.white)
                                .scaleEffect(isPhone() ? 1 : 0.4)
                                .frame(maxHeight: 200)
                                .clipShape(Circle())
                                .overlay {
                                    Circle()
                                        .stroke(Color.white, lineWidth: 1)
                                }
                                .overlay(alignment: .bottom) {
                                    Button {
                                        isShowingImageAlternatives = true
                                    } label: {
                                        Image(systemName: "camera.on.rectangle.fill")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 30)
                                            .foregroundColor(.accentColor)
                                    }
                                    .offset(x: 100)
                                }
                        case .failure( _):
                            Image(systemName: "person")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .scaleEffect(0.7)
                                .foregroundColor(.white)
                                .frame(maxHeight: 200)
                                .clipShape(Circle())
                                .overlay {
                                    Circle()
                                        .stroke(Color.white, lineWidth: 1)
                                }
                                .overlay(alignment: .bottom) {
                                    Button {
                                        isShowingImageAlternatives = true
                                    } label: {
                                        Image(systemName: "camera.on.rectangle.fill")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 30)
                                            .foregroundColor(.accentColor)
                                    }
                                    .offset(x: 100)
                                }
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .fullScreenCover(isPresented: $isShowingCameraPicker) {
                        ImagePickerHostView(customer: customerVM.customer, isShown: $isShowingCameraPicker, error: $error, image: $image, isCamera: isCamera)
                    }
                }
                    
                
                CustomInputView(title: "Name",
                                image: "person.text.rectangle.fill",
                                editing: $editingName,
                                text: $customerVM.name,
                                keyboardTag: 3,
                                keyboardType: .alphabet,
                                autocapitalizationType: .words)
                
                CustomInputView(title: "E-mail address",
                                image: "envelope.fill",
                                editing: $editingEmail,
                                text: $customerVM.email,
                                keyboardTag: 4,
                                keyboardType: .emailAddress)
                

                Button {
                    adjustingBalance = true
                } label: {
                    Text("Adjust balance")
                        .frame(width: 300, height: 44, alignment: .center)
                        .background(Color.accentColor)
                        .cornerRadius(4)
                        .foregroundColor(.white)
                }
                                
                VStack(alignment: .leading) {
                    HStack {
                        Spacer()
                    }
                    .frame(width: 300, height: 24)
                    .padding()
                    .overlay(alignment: .leading) {
                        if userHandler.user.usingTags {
                            Button {
                                isShowingKeyField.toggle()
                            } label: {
                                Text("Update \nRFID tag")
                                    .multilineTextAlignment(.leading)
                                    .fixedSize()
                                    .frame(width: 160, height: 24, alignment: .leading)
                                    .padding()
                                    .background(Color.accentColor)
                                    .cornerRadius(6)
                                    .contentShape(Rectangle())
                            }
                            .overlay(alignment: .trailing) {
                                Image(systemName: "wave.3.right.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .padding()
                            }
                            .foregroundColor(.white)
                            .sheet(isPresented: $isShowingKeyField) {
                                UpdateTagView(customer: customerVM.customer)
                                    .clearModalBackground()
                            }
                        }
                    }
                    .overlay(alignment: .trailing) {
                        Button {
                            showError.toggle()
                        } label: {
                            Image(systemName: "trash.square.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.red)
                        }
                        .alert(isPresented: $showError) {
                            Alert(title: Text("Delete bar guest"),
                                  message: Text("Are you sure you want to delete this bar guest?"),
                                  primaryButton: .default(Text("Cancel")),
                                  secondaryButton: .destructive(Text("Delete")) {
                                customerListVM.removeCustomer(customerVM.customer)
                                detailsViewShown = .none
                            })
                        }
                    }
                }
                .padding(.top, 48)
                
                Spacer()
            }
            Spacer()
        }
        .overlay(alignment: .topLeading) {
            if isPhone() {
                Button {
                    withAnimation {
                        detailsViewShown = .none
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .padding()
                        .foregroundColor(.white)
                        .opacity(0.6)
                        .contentShape(Rectangle().size(width: 40, height: 40))
                }
            }
        }
        .overlay(alignment: .center) {
            if isShowingImageAlternatives {
                ImageAlternativesView(isShowingImageAlternatives: $isShowingImageAlternatives, isShowingCameraPicker: $isShowingCameraPicker, isCamera: $isCamera)
            }
        }
        .preferredColorScheme(.dark)
        .fullScreenCover(isPresented: $adjustingBalance) {
            AdjustBalanceView(customerName: customerVM.name, currentBalance: customerVM.customer.balance, showingAdjustmentView: $adjustingBalance)
                .clearModalBackground()
        }
    }
    
    private func isPhone() -> Bool {
        return !(horizontalSizeClass == .regular && verticalSizeClass == .regular)
    }
}
