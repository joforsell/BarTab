//
//  ImageAlternativesView.swift
//  BarTab
//
//  Created by Johan Forsell on 2022-05-19.
//

import SwiftUI
import SwiftUIX
import AVKit

struct ImageAlternativesView: View {
    @Binding var isShowingImageAlternatives: Bool
    @Binding var isShowingCameraPicker: Bool
    @Binding var isCamera: Bool
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    switch AVCaptureDevice.authorizationStatus(for: .video) {
                    case .authorized:
                        isCamera = true
                        isShowingImageAlternatives = false
                        isShowingCameraPicker = true
                    case .notDetermined:
                        AVCaptureDevice.requestAccess(for: .video) { granted in
                            if granted {
                                isCamera = true
                                isShowingImageAlternatives = false
                                isShowingCameraPicker = true
                            }
                        }
                    case .denied:
                        isShowingImageAlternatives = false
                    case .restricted:
                        isShowingImageAlternatives = false
                    @unknown default:
                        isShowingImageAlternatives = false
                    }
                } label: {
                    Image(systemName: "camera.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 44)
                }
                .padding(.trailing, 44)
                Button {switch AVCaptureDevice.authorizationStatus(for: .video) {
                case .authorized:
                    isCamera = false
                    isShowingImageAlternatives = false
                    isShowingCameraPicker = true
                case .notDetermined:
                    AVCaptureDevice.requestAccess(for: .video) { granted in
                        if granted {
                            isCamera = false
                            isShowingImageAlternatives = false
                            isShowingCameraPicker = true
                        }
                    }
                case .denied:
                    isShowingImageAlternatives = false
                case .restricted:
                    isShowingImageAlternatives = false
                @unknown default:
                    isShowingImageAlternatives = false
                }
                } label: {
                    Image(systemName: "photo.fill.on.rectangle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 44)
                }
            }
            .padding()
            .foregroundColor(.accentColor)
            Divider()
            Button {
                isShowingImageAlternatives = false
            } label: {
                Text("Cancel")
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .contentShape(Rectangle())
            }
        }
        .frame(maxWidth: UIScreen.main.bounds.width * 0.6)
        .padding()
        .background(VisualEffectBlurView(blurStyle: .dark))
        .cornerRadius(10)
    }
}
