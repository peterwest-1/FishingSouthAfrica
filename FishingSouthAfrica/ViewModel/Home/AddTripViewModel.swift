//
//  CreateFishingTripViewModel.swift
//  FishingSouthAfrica
//
//  Created by Pete West on 2022/04/05.
//

import FirebaseAuth
import SwiftUI

protocol AddTripViewModelProtocol {
    func addTrip(completion: @escaping
        (Result<Fish, Error>) -> Void)
}

final class AddTripViewModel: ObservableObject {
    @Published var name = ""
    @Published var locationName = ""
    @Published var dateStart = Date()
    @Published var dateFinish = Date()

    @Published private(set) var state: LoadingState<Bool> = LoadingState.idle

    init() {
        self.state = .loaded(true)
    }
}

extension AddTripViewModel: AddTripViewModelProtocol {
    func addTrip(completion: @escaping
        (Result<Fish, Error>) -> Void = { _ in })
    {
        state = .loading
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

        TripService.shared.addTrip(trip: trip) { result in
            switch result {
                case .success(_):
                    self.state = .loaded(true)
                case .failure(let error):
                    self.state = .failed(error)
            }
        }
    }
}
