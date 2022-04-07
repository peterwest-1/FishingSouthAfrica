//
//  FishingTripService.swift
//  FishingSouthAfrica
//
//  Created by Pete West on 2022/04/03.
//

import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage
import FirebaseStorageSwift
import SwiftUI

enum FishError: Error {
    case Edit
    case Image
    case Delete
}

struct FishService {
    let db = Firestore.firestore()

    static let shared = FishService()

    /// Adds Fish to Fish Collection in Firestore
    /// - Parameters:
    ///   - fish: Fish
    ///   - completion: Optional Completion Handler
    private func addFishToCollection(fish: Fish, completion: @escaping
        () -> Void = {})
    {
        var fishReference: DocumentReference?

        fishReference = db.collection(Collections.FISH_COLLECTION).document(fish.UUID)
        try? fishReference?.setData(from: fish)
        completion()
    }

    /// Adds the Trip UUID to the Fish to save on which trip it was caught
    /// - Parameters:
    ///   - fish: Fish
    ///   - trip: Trip
    ///   - completion: Optional Completion Handler
    @available(*, deprecated, message: "Trip is add when creating fish now")
    private func addTripToFish(fish: Fish, trip: Trip, completion: @escaping
        () -> Void = {})
    {
        var fishReference: DocumentReference?
        fishReference = db.collection(Collections.TRIPS_COLLECTION).document(trip.UUID)
        fishReference?.updateData([
            "trip": FieldValue.arrayUnion(["\(trip.UUID)"]),
            "updatedAt": Date().ISO8601Format(),
        ])
        completion()
    }

    public func addFish(fish: Fish, trip: Trip, completion: @escaping
        (Result<Bool, Error>) -> Void = { _ in })
    {
        /*
         Steps
          1. Add Fish To Collection
          2. Add Fish To Trip
          3. Add Trip to Fish - Should be done when creating fish actually
          4. Add Fish To User
          */
        addFishToCollection(fish: fish) {
            TripService.shared.addFishToTrip(fish: fish, trip: trip) { result in
                switch result {
                    case .success:
                        UserService.shared.addFishToUser(fish: fish) { result in
                            switch result {
                                case .success(let res):
                                    completion(.success(res))
                                case .failure(let err):
                                    completion(.failure(err))
                            }
                        }
                    case .failure(let err):
                        completion(.failure(err))
                }
            }
        }
    }

    public func editFish(fish: Fish, completion: @escaping
        (Result<Fish, Error>) -> Void = { _ in })
    {
        var json: [String: Any]?

        let jsonEncoder = JSONEncoder()
        let encodedJson = try? jsonEncoder.encode(fish)
        json = try? JSONSerialization.jsonObject(with: encodedJson!) as? [String: Any]

        if var updated = json {
            updated.removeValue(forKey: "createdAt")
            updated["timeCaught"] = fish.timeCaught
            updated["fightDuration"] = fish.fightDuration
            updated["updatedAt"] = Date()

            var fishReference: DocumentReference?
            fishReference = db.collection(Collections.FISH_COLLECTION).document(fish.UUID)

            fishReference?.updateData(updated, completion: { error in
                if let error = error {
                    print("Error Editing 1")
                    completion(.failure(error))
                } else {
                    completion(.success(fish))
                }
            })
        } else {
            print("Error Editing 2")
            completion(.failure(FishError.Edit))
        }
    }

    
    
    /// Delete fish from database
    ///     1. Delete fish from colection
    ///     2. Remove from Trip
    ///     3. Remove from User
    ///        4. Remove image of fish
    /// - Parameters:
    ///   - fish: Fish
    ///   - trip: Trip
    ///   - completion: Optional Completion Handler
    public func deleteFish(fish: Fish, completion: @escaping
        (Result<Fish, Error>) -> Void = { _ in })
    {
        deleteFishFromCollection(fish: fish) {
            getTripFromFish(fish: fish) { result in
                switch result {
                    case .success(let trip):
                        TripService.shared.deleteFishFromTrip(fish: fish, trip: trip) {
                            UserService.shared.deleteFishFromUser(fish: fish) {
                                StorageManager.shared.removeFishImageFromStorage(fish: fish) { result in
                                    switch result {
                                        case .success:
                                            completion(.success(fish))
                                        case .failure(let error):
                                            completion(.failure(error))
                                    }
                                }
                            }
                        }
                    case .failure(let error):
                        completion(.failure(error))
                }
            }
        }
    }

    private func getTripFromFish(fish: Fish, completion: @escaping
        (Result<Trip, Error>) -> Void = { _ in })
    {
        db.collection(Collections.TRIPS_COLLECTION).whereField("fish", arrayContains: fish.UUID).getDocuments { querySnapshot, err in
            if let err = err {
                completion(.failure(err))
            } else {
                for document in querySnapshot!.documents {
                    var x: Trip?
                    do {
                        x = try document.data(as: Trip.self)
                    } catch {
                        print(error)
                    }
                    if let trip = x {
                        completion(.success(trip))
                    }
                }
            }
        }
    }

    /// Remove Fish From Collection
    /// - Parameters:
    ///   - fish: Fish to be removed
    ///   - completion: Optional Completion Handler
    private func deleteFishFromCollection(fish: Fish, completion: @escaping
        () -> Void = {})
    {
        db.collection(Collections.FISH_COLLECTION).document(fish.UUID).delete { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                completion()
            }
        }
    }

    /// Removes Trip reference from Fish
    /// - Parameters:
    ///   - fish: Fish
    ///   - completion: Optional Completion Handler
    public func removeTripFromFish(fish: Fish, completion: @escaping
        () -> Void = {})
    {
        db.collection(Collections.FISH_COLLECTION).document(fish.UUID).updateData([
            "trip": FieldValue.delete(),
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                completion()
            }
        }
    }

    public func getFishForTrip(trip: Trip, completion: @escaping
        (Result<[Fish], Error>) -> Void)
    {
        let tripValue = "trip"
        var fish = [Fish]()
        db.collection(Collections.FISH_COLLECTION).whereField(tripValue, isEqualTo: trip.UUID).getDocuments { querySnapshot, err in
            if let err = err {
                completion(.failure(err))
            } else {
                for document in querySnapshot!.documents {
                    var x: Fish?
                    do {
                        x = try document.data(as: Fish.self)
                    } catch {
                        print(error)
                    }
                    if let fsh = x {
                        fish.append(fsh)
                    }
                }
                completion(.success(fish))
            }
        }
    }

    func uploadFishImage(image: UIImage, fish: Fish, completion: @escaping
        (String?) -> Void)
    {
        let storageManager = StorageManager()
        storageManager.persistFishImageToStorage(image: image, fish: fish)
    }

    func storeFishImageInformation(image: URL, fish: Fish, completion: @escaping
        (Result<URL, Error>) -> Void = { _ in })
    {
        let fishData = ["image": image.absoluteString, "updatedAt": Date()] as [String: Any]
        db.collection(Collections.FISH_COLLECTION).document(fish.UUID).updateData(fishData) { err in
            if let err = err {
                print(err)
                completion(.failure(err))
                return
            }

            completion(.success(image))
        }
    }
}
