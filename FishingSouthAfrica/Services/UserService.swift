//
//  UserService.swift
//  FishingSouthAfrica
//
//  Created by Pete West on 2022/04/05.
//

import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage
import FirebaseStorageSwift
import SwiftUI

struct UserService
{
    let db = Firestore.firestore()
    static let shared = UserService()

    /// Adds Fish UUID to the User in the database
    /// - Parameters:
    ///   - fish: Fish
    ///   - completion: Optional Completion Handler
    public func addFishToUser(fish: Fish, completion: @escaping
                              (Result<Bool, Error>) -> Void = {result in })
    {
        let currentUserUID = Auth.auth().currentUser?.uid ?? "UserService:addFishToUser"
        let userRef = db.collection(Collections.USER_COLLECTION).document(currentUserUID)
 
        userRef.updateData([
            "fish": FieldValue.arrayUnion(["\(fish.UUID)"]),
            "updatedAt": Date()
        ]) { error in
            if let err = error {
                completion(.failure(err))
            }else {
                completion(.success(true))
            }
            
        }
        
    }

    /// Adds Trip UUID to the User in the database
    /// - Parameters:
    ///   - trip: Trip
    ///   - completion: Optional Completion Handler
    public func addTripToUser(trip: Trip, completion: @escaping
                              (Result<Trip, Error>) -> Void = { _ in })
    {
        let currentUserUID = Auth.auth().currentUser?.uid ?? "UserService:addTripToUser"

        let userRef = db.collection(Collections.USER_COLLECTION).document(currentUserUID)
        userRef.updateData([
            "trips": FieldValue.arrayUnion(["\(trip.UUID)"]),
            "updatedAt": Date()
        ]) { error in
            if let error = error {
                completion(.failure(error))
            }
            completion(.success(trip))
        }
    }

    /// Initializes User into the User collection in the databse
    /// - Parameter uid: UID for the current User
    public func addUser(uid: String)
    {
        addUserToCollection(uid: uid)
    }

    /// Initializes User into the User collection in the databse
    /// - Parameter uid: UID for the current User
    private func addUserToCollection(uid: String)
    {
        let user: [String: Any] = [
            "createdAt": Date(),
            "updatedAt": Date(),
            "trips": [],
            "fish": []
        ]

        db.collection(Collections.USER_COLLECTION).document(uid).setData(user)
        { err in
            if let err = err
            {
                print("Error writing document: \(err)")
            }
            else
            {
                print("Document successfully written!")
            }
        }
    }

    /// Remove Fish From User
    /// - Parameters:
    ///   - fish: Fish to be removed
    ///   - completion: Optional Completion Handler
    public func deleteFishFromUser(fish: Fish, completion: @escaping
        () -> Void = {})
    {
        let currentUserUID = Auth.auth().currentUser?.uid ?? "UserService:deleteFishFromUser"

        let userRef = db.collection(Collections.USER_COLLECTION).document(currentUserUID)
        userRef.updateData([
            "fish": FieldValue.arrayRemove(["\(fish.UUID)"]),
            "updatedAt": Date()
        ])
        completion()
    }

    /// Remove Trip From User
    /// - Parameters:
    ///   - trip: Trip to be removed
    ///   - completion: Optional Completion Handler
    public func deleteTripFromUser(trip: Trip, completion: @escaping
        () -> Void = {})
    {
        let currentUserUID = Auth.auth().currentUser?.uid ?? "UserService:deleteTripFromUser"

        let userRef = db.collection(Collections.USER_COLLECTION).document(currentUserUID)
        userRef.updateData([
            "trips": FieldValue.arrayRemove(["\(trip.UUID)"]),
            "updatedAt": Date().ISO8601Format()
        ])
        completion()
    }
}
