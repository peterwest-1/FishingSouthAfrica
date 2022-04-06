//
//  CreateFishingTripViewModel.swift
//  FishingSouthAfrica
//
//  Created by Pete West on 2022/04/05.
//

import FirebaseAuth
import SwiftUI

protocol AddTripViewModelProtocol {
    func addTrip()
}

final class AddTripViewModel: ObservableObject {
    @Published var name = ""
    @Published var locationName = ""
    @Published var dateStart = Date()
    @Published var dateFinish = Date()
}

extension AddTripViewModel: AddTripViewModelProtocol {
    func addTrip() {
        let trip = Trip(id: UUID(),
                        owner: Auth.auth().currentUser?.uid ?? "CreateFishingTripViewModel:addFishingTrip",
                        name: name,
                        dateStart: dateStart,
                        dateFinish: dateFinish,
                        latitude: 0.0,
                        longitude: 0.0,
                        locationName: locationName,
                        friends: nil,
                        fish: [],
                        images: [],
                        createdAt: Date(),
                        updatedAt: Date())

        TripService.shared.addTrip(trip: trip)
    }
}
