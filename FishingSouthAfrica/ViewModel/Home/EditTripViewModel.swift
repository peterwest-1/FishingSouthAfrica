//
//  EditTripViewModel.swift
//  FishingSouthAfrica
//
//  Created by Pete West on 2022/04/06.
//

import Foundation

import FirebaseAuth
import SwiftUI

protocol EditTripViewModelProtocol {
    func editTrip()
}

final class EditTripViewModel: ObservableObject {
    @Published var name: String
    @Published var locationName: String
    @Published var dateStart: Date
    @Published var dateFinish: Date

    var trip: Trip

    init(trip: Trip) {
        self.trip = trip
        name = trip.name.unsafelyUnwrapped
        locationName = trip.locationName.unsafelyUnwrapped
        dateStart = trip.dateStart.unsafelyUnwrapped
        dateFinish = trip.dateFinish.unsafelyUnwrapped
    }
}

extension EditTripViewModel: EditTripViewModelProtocol {
    func editTrip() {
        let updated = Trip(
            id: trip.id,
            owner: trip.owner,
            name: name,
            dateStart: dateStart,
            dateFinish: dateFinish,
            latitude: trip.latitude,
            longitude: trip.longitude,
            locationName: locationName,
            friends: nil,
            fish: trip.fish,
            images: trip.images,
            createdAt: trip.createdAt,
            updatedAt: Date())

        TripService.shared.editTrip(trip: updated)
    }
}
