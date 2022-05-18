//
//  CacheableAsyncImage.swift
//  BarTab
//
//  Created by Johan Forsell on 2022-05-17.
//

import SwiftUI

struct CacheableAsyncImage<Content: View>: View {
    
    @StateObject private var manager = CachedImageManager()
    @Binding var url: String?
    let animation: Animation?
    let transition: AnyTransition
    let content: (AsyncImagePhase) -> Content
    
    init(url: Binding<String?>,
         animation: Animation? = nil,
         transition: AnyTransition = .identity,
         @ViewBuilder content: @escaping (AsyncImagePhase) -> Content) {
        _url = url
        self.animation = animation
        self.transition = transition
        self.content = content
    }
    
    var body: some View {
        ZStack {
            switch manager.currentState {
            case .loading:
                content(.empty)
                    .transition(transition)
            case .success(let data):
                if let image = UIImage(data: data) {
                    content(.success(Image(uiImage: image)))
                        .transition(transition)
                } else {
                    content(.failure(CachedImageError.invalidData))
                        .transition(transition)
                }
            case .failed(let error):
                content(.failure(error))
                    .transition(transition)
            default:
                content(.empty)
                    .transition(transition)
            }
        }
        .animation(animation, value: manager.currentState)
        .task {
            await manager.load(url)
        }
        .onChange(of: url) { url in
            Task {
                await manager.load(url)
            }
        }
    }
}

extension CacheableAsyncImage {
    enum CachedImageError: Error {
        case invalidData
    }
}
