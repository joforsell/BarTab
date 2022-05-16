//
//  ImageCloud.swift
//  BarTab
//
//  Created by Johan Forsell on 2022-05-13.
//

import Foundation
import SwiftUI
import Firebase

class ImageCloud {
    
    static func uploadProfilePicture(_ image: UIImage, for customer: Customer, completion: @escaping (Result<URL, UploadError>) -> ()) {

        guard let customerID = customer.id else {
            completion(.failure(.missingId))
            return
        }
        
        guard let imageData = image.jpegData(compressionQuality: 0.4) else {
            completion(.failure(.missingImageData))
            return
        }
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let pictureRef = storageRef.child("profilePics/\(customerID).jpg")
        let imageMetadata = StorageMetadata()
        imageMetadata.contentType = "image/jpeg"
        
        pictureRef.putData(imageData, metadata: imageMetadata) { metadata, error in
            if let _ = error {
                completion(.failure(.uploadFailed))
            } else {
                pictureRef.downloadURL { url, error in
                    guard let downloadURL = url else {
                        completion(.failure(.missingDownloadLink))
                        return
                    }
                    
                    completion(.success(downloadURL))
                    return
                }
            }
        }
    }
}

enum UploadError: Error {
    case missingId
    case missingDownloadLink
    case missingImageData
    case uploadFailed
    
    var customMessage: LocalizedStringKey {
        switch self {
        case .missingId:
            return "Unable to specify user."
        case .missingDownloadLink:
            return "Could not fetch download link."
        case .missingImageData:
            return "Could not make image data."
        case .uploadFailed:
            return "Failed to upload picture"
        }
    }
}
