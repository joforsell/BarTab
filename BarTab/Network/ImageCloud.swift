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
    
    typealias CacheType = NSCache<NSString, NSData>
    
    static let shared = ImageCloud()
    
    private init() {}
    
    private lazy var cache: CacheType = {
        let cache = CacheType()
        cache.countLimit = 100
        cache.totalCostLimit = 50 * 1024 * 1024
        return cache
    }()
    
    func object(forKey key: NSString) -> Data? {
        cache.object(forKey: key) as? Data
    }
    
    func set(object: NSData, forKey key: NSString) {
        cache.setObject(object, forKey: key)
    }
    
    static func fetchProfilePicture(from url: String) async throws -> Data {
        guard let url = URL(string: url) else {
            throw DownloadError.invalidUrl
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
    
    static func uploadProfilePicture(_ image: UIImage, for customer: Customer, completion: @escaping (Result<URL, UploadError>) -> ()) {
        
        print("Calling static function")

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
                    print("Should send URL back")
                    return
                }
            }
        }
    }
}

enum DownloadError: Error {
    case invalidUrl
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
