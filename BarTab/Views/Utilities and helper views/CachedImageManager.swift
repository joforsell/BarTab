//
//  CachedImageManager.swift
//  BarTab
//
//  Created by Johan Forsell on 2022-05-17.
//

import Foundation

final class CachedImageManager: ObservableObject {
    
    @Published var currentState: CurrentState?
    
    @MainActor
    func load(_ url: String?, cache: ImageCloud = .shared) async {
        
        self.currentState = .loading
        
        if let url = url {
            if let imageData = cache.object(forKey: url as NSString) {
                self.currentState = .success(data: imageData)
                return
            }
            do {
                let data = try await ImageCloud.fetchProfilePicture(from: url)
                self.currentState = .success(data: data)
                cache.set(object: data as NSData, forKey: url as NSString)
            } catch {
                self.currentState = .failed(error: error)
            }
        } else {
            self.currentState = .failed(error: ImageError.noImage)
        }
    }
}

extension CachedImageManager {
    enum CurrentState {
        case loading
        case failed(error: Error)
        case success(data: Data)
    }
    
    enum ImageError: Error {
        case noImage
    }
}

extension CachedImageManager.CurrentState: Equatable {
    static func == (lhs: CachedImageManager.CurrentState, rhs: CachedImageManager.CurrentState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading):
            return true
        case (let .failed(lhsError), let .failed(rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        case (let .success(lhsData), let .success(rhsData)):
            return lhsData == rhsData
        default:
            return false
        }
    }
}
