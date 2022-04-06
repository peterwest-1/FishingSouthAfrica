//
//  RemoteImageModel.swift
//  FishingSouthAfrica
//
//  Created by Pete West on 2022/04/04.
//

import SwiftUI
import Combine

class RemoteImageModel: ObservableObject {
    @Published var displayImage: UIImage?
    var imageUrl: String?
    var cachedImage = CachedImage.getCachedImage()

    init(imageUrl: String?) {
        self.imageUrl = imageUrl
        if imageFromCache() {
            return
        }
        imageFromRemoteUrl()
    }

    func imageFromCache() -> Bool {
        guard let url = imageUrl, let cacheImage = cachedImage.get(key: url) else {
            return false
        }
        displayImage = cacheImage
        return true
    }

    func imageFromRemoteUrl() {
        guard let url = imageUrl else {
            return
        }

        let imageURL = URL(string: url)!

        URLSession.shared.dataTask(with: imageURL, completionHandler: { data, _, _ in
            if let data = data {
                DispatchQueue.main.async {
                    guard let remoteImage = UIImage(data: data) else {
                        return
                    }

                    self.cachedImage.set(key: self.imageUrl!, image: remoteImage)
                    self.displayImage = remoteImage
                }
            }
        }).resume()
    }
}

class CachedImage {
    var cache = NSCache<NSString, UIImage>()

    func get(key: String) -> UIImage? {
        return cache.object(forKey: NSString(string: key))
    }

    func set(key: String, image: UIImage) {
        cache.setObject(image, forKey: NSString(string: key))
    }
}

extension CachedImage {
    private static var cachedImage = CachedImage()
    static func getCachedImage() -> CachedImage {
        return cachedImage
    }
}

class LoadUrlImage: ObservableObject {
    @Published var data = Data()
    init(imageURL: String) {
        let cache = URLCache.shared
        let request = URLRequest(url: URL(string: imageURL)!, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 60.0)
        if let data = cache.cachedResponse(for: request)?.data {
            self.data = data
        } else {
            URLSession.shared.dataTask(with: request, completionHandler: { data, response, _ in
                if let data = data, let response = response {
                    let cachedData = CachedURLResponse(response: response, data: data)
                    cache.storeCachedResponse(cachedData, for: request)
                    DispatchQueue.main.async {
                        self.data = data
                    }
                }
            }).resume()
        }
    }
}

struct ImageViewController: View {
    @ObservedObject var url: LoadUrlImage

    init(imageUrl: String) {
        url = LoadUrlImage(imageURL: imageUrl)
    }

    var body: some View {
        Image(uiImage: UIImage(data: self.url.data) ?? UIImage())
            .resizable()
            .clipped()
    }
}
