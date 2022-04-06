//
//  HomeViewModel.swift
//  FishingSouthAfrica
//
//  Created by Pete West on 2022/04/03.
//

import Foundation

protocol HomeViewModelProtocol {
    func fetchTrips()
}

final class HomeViewModel: ObservableObject {
    @Published var trips = [Trip]()
    @Published private(set) var state: LoadingState<[Trip]> = LoadingState.idle

    init() {
        fetchTrips()
    }
}

extension HomeViewModel: HomeViewModelProtocol {
    func fetchTrips() {
        state = .loading
        TripService.shared.getTrips(amount: 1) { result in
            switch result {
                case .success(let trips):
                    self.state = .loaded(trips)
                    self.trips = trips
                case .failure(let error):
                    self.state = .failed(error)
            }
        }
    }

    func deleteTrip(trip: Trip) {
        TripService.shared.deleteTrip(trip: trip)
    }
}
