//
//  ImagePicker.swift
//  BarTab
//
//  Created by Johan Forsell on 2022-05-13.
//

import Foundation
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
        
    @Binding var customer: Customer
    @Binding var isShown: Bool
    @Binding var error: UploadError?
    @Binding var loading: Bool
    let isCamera: Bool

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        //
    }
    
    func makeCoordinator() -> ImagePickerCoordinator {
        return ImagePickerCoordinator(customer: $customer, isShown: $isShown, error: $error, loading: $loading)
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        if isCamera {
            picker.sourceType = .camera
        }
        return picker
    }
}

class ImagePickerCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @Binding var customer: Customer
    @Binding var isShown: Bool
    @Binding var error: UploadError?
    @Binding var loading: Bool

    init(customer: Binding<Customer>, isShown: Binding<Bool>, error: Binding<UploadError?>, loading: Binding<Bool>) {
        _customer = customer
        _isShown = isShown
        _error = error
        _loading = loading
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let uiImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        loading = true
        ImageCloud.uploadProfilePicture(uiImage, for: customer) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                self.error = error
                self.loading = false
                self.isShown = false
            case .success(let url):
                CustomerRepository.updateProfilePictureUrl(for: self.customer, to: url)
                self.customer.profilePictureUrl = url.absoluteString
                self.loading = false
                self.isShown = false
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        isShown = false
    }
}
