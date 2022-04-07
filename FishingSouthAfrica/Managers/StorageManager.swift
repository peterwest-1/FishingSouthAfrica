//
//  StorageManager.swift
//  FishingSouthAfrica
//
//  Created by Pete West on 2022/04/04.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage
import FirebaseStorageSwift
import SwiftUI

enum ImageStoragePath: String {
    case FISH = "fish"
    case TRIPS = "trips"
}

public class StorageManager: ObservableObject {
    let storage = Storage.storage()

    static let shared = StorageManager()
    
    public func persistFishImageToStorage(image: UIImage, fish: Fish, completion: @escaping (Result<URL, Error>) -> Void = { _ in }) {
        let ref = storage.reference(withPath: fish.UUID)
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        ref.putData(imageData, metadata: nil) { _, err in
            if let err = err {
                completion(.failure(err))
            }

            ref.downloadURL { url, err in
                if let err = err {
                    completion(.failure(err))
                }

                guard let url = url else { return }
                FishService.shared.storeFishImageInformation(image: url, fish: fish) { result in
                    switch result {
                        case .success(let url):
                            completion(.success(url))
                        case .failure(let error):
                            completion(.failure(error))
                    }
                }
            }
        }
    }

    public func removeFishImageFromStorage(fish: Fish, completion: @escaping (Result<Bool, Error>) -> Void = { _ in }) {
        let ref = storage.reference(withPath: fish.UUID)

        // Delete the file
        ref.delete { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }
}
