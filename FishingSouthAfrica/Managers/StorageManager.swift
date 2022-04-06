//
//  StorageManager.swift
//  FishingSouthAfrica
//
//  Created by Pete West on 2022/04/04.
//

import SwiftUI
import FirebaseStorage
import FirebaseStorageSwift

enum ImageStoragePath: String {
    case FISH = "fish"
    case TRIPS = "trips"
}
public class StorageManager: ObservableObject {
    let storage = Storage.storage()

    func upload(image: UIImage, path: String, completion: @escaping (String?) -> Void ){
        // Create a storage reference
        let filenameUUID = UUID().uuidString
        let storageRef = storage.reference().child("\(path)/\(filenameUUID).jpg")

        // Resize the image to 200px with a custom extension
//        let resizedImage = image.aspectFittedToHeight(200)

        // Convert the image into JPEG and compress the quality to reduce its size
        let data = image.jpegData(compressionQuality: 0.3)

        // Change the content type to jpg. If you don't, it'll be saved as application/octet-stream type
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"

        // Upload the image
        if let data = data {
            storageRef.putData(data, metadata: metadata) { metadata, error in
                if let error = error {
                    print("Error while uploading file: ", error)
                    
                }

                if let metadata = metadata {
                    print("Metadata: ", metadata)
                    completion( metadata.path)
                }
            }
        }
    }
}
