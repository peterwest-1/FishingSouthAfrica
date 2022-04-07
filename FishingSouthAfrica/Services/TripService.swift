//
//  TripService.swift
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

struct TripService
{
    let db = Firestore.firestore()

    static let shared = TripService()

    /// Adds Trip to the database
    /// - Parameters:
    ///   - trip: Trip
    ///   - completion: Completion Handler
    private func addTripToCollection(trip: Trip, completion: @escaping
        (Result<Trip, Error>) -> Void = { _ in })
    {
        var tripReference: DocumentReference?
        tripReference = db.collection(Collections.TRIPS_COLLECTION).document(trip.UUID)
        try? tripReference?.setData(from: trip, completion: { error in
            if let error = error
            {
                completion(.failure(error))
            }
            completion(.success(trip))
        })
    }

    public func addTrip(trip: Trip, completion: @escaping
        (Result<Trip, Error>) -> Void = { _ in })
    {
        addTripToCollection(trip: trip) { result in
            switch result {
                case .success(let trip):
                    UserService.shared.addTripToUser(trip: trip) { result in
                        switch result {
                            case .success(let trip):
                                completion(.success(trip))
                            case .failure(let error):
                                completion(.failure(error))
                        }
                    }
                case .failure(let error):
                    completion(.failure(error))
            }
        }
        
    }

    public func editTrip(trip: Trip, completion: @escaping
        (Result<Bool, Error>) -> Void = { _ in })
    {
        var json: [String: Any]?

        let jsonEncoder = JSONEncoder()
        let encodedJson = try? jsonEncoder.encode(trip)
        json = try? JSONSerialization.jsonObject(with: encodedJson!) as? [String: Any]

        if var updated = json
        {
            updated.removeValue(forKey: "createdAt")
            updated["dateStart"] = trip.dateStart
            updated["dateFinish"] = trip.dateFinish
            updated["updatedAt"] = Date()

            var fishReference: DocumentReference?
            fishReference = db.collection(Collections.TRIPS_COLLECTION).document(trip.UUID)

            fishReference?.updateData(updated, completion: { error in
                if let error = error
                {
                    print("Error Editing 1")
                    completion(.failure(error))
                }
                else
                {
                    completion(.success(true))
                }
            })
        }
        else
        {
            print("Error Editing 2")
            completion(.failure(FishError.Edit))
        }
    }

    public func deleteTrip(trip: Trip, completion: @escaping
        () -> Void = {})
    {
        deleteTripFromCollection(trip: trip)
        {
            UserService.shared.deleteTripFromUser(trip: trip)
            {
                // TODO: Remove references to Trips on Fish
                completion()
            }
        }
    }

    /// Removes Trip from Collection
    /// - Parameters:
    ///   - trip: Trip to be removed
    ///   - completion: Optinal Completion Handler
    private func deleteTripFromCollection(trip: Trip, completion: @escaping
        () -> Void = {})
    {
        db.collection(Collections.TRIPS_COLLECTION).document(trip.UUID).delete
        { err in
            if let err = err
            {
                print("Error removing document: \(err)")
            }
            else
            {
                print("Document successfully removed!")
            }
        }
    }

    /// Adds Fish to Trip in the database
    /// - Parameters:
    ///   - fish: Fish
    ///   - trip: Trip
    ///   - completion: Completion handler
    public func addFishToTrip(fish: Fish, trip: Trip, completion: @escaping
        (Result<Bool, Error>) -> Void = { _ in })
    {
        var tripReference: DocumentReference?
        tripReference = db.collection(Collections.TRIPS_COLLECTION).document(trip.UUID)
        tripReference?.updateData([
            "fish": FieldValue.arrayUnion(["\(fish.UUID)"]),
            "updatedAt": Date()
        ], completion: { error in
            if let err = error
            {
                completion(.failure(err))
            }
            else
            {
                completion(.success(true))
            }
        })
    }

    /// Removes Fish from Trip
    /// - Parameters:
    ///   - fish: Fish to be removed
    ///   - trip: In the Trip
    ///   - completion: Optional Completion Handler
    public func deleteFishFromTrip(fish: Fish, trip: Trip, completion: @escaping
        () -> Void = {})
    {
        var tripReference: DocumentReference?
        tripReference = db.collection(Collections.TRIPS_COLLECTION).document(trip.UUID)
        tripReference?.updateData([
            "fish": FieldValue.arrayRemove(["\(fish.UUID)"]),
            "updatedAt": Date()
        ])
    }

    /// Gets Trips for current user
    /// - Parameters:
    ///   - amount: Amount of Trips to get
    ///   - completion: Returns Array of Trips
    public func getTrips(amount: Int, completion: @escaping
        (Result<[Trip], Error>) -> Void)
    {
        let currentUserUID = Auth.auth().currentUser?.uid ?? "TripService:getTrips"
        let owner = "owner"
        print("User ID", currentUserUID)
        var trips = [Trip]()
        db.collection(Collections.TRIPS_COLLECTION).whereField(owner, isEqualTo: currentUserUID).getDocuments
        { querySnapshot, err in
            if let err = err
            {
                completion(.failure(err))
            }
            else
            {
                for document in querySnapshot!.documents
                {
                    var x: Trip?
                    do
                    {
                        x = try document.data(as: Trip.self)
                    }
                    catch
                    {
                        print(error)
                    }

                    if let trip = x
                    {
                        trips.append(trip)
                    }
                }
                completion(.success(trips))
            }
        }
    }
}
