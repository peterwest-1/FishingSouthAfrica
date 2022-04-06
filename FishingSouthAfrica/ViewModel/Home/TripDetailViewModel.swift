//
//  FishingTripDetailViewModelProtocol.swift
//  FishingSouthAfrica
//
//  Created by Pete West on 2022/04/04.
//

import Foundation

protocol TripDetailViewModelProtocol {
    func fetchFish()
}

final class TripDetailViewModel: ObservableObject {
    @Published var fish = [Fish]()
    @Published private(set) var state: LoadingState<[Fish]> = LoadingState.idle

    let service = FishService.shared
    var trip: Trip

    init(trip: Trip) {
        self.trip = trip

        fetchFish()
    }
}

extension TripDetailViewModel: TripDetailViewModelProtocol {
    func fetchFish() {
        state = .loading
        service.getFishForTrip(trip: trip, completion: { result in
            switch result {
            case .success(let fish):
                self.state = .loaded(fish)
                self.fish = fish
            case .failure(let error):
                self.state = .failed(error)
            }
        })
    }
}
