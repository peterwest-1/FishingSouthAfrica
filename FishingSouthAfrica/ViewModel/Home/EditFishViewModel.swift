//
//  EditFishCaughtViewModel.swift
//  FishingSouthAfrica
//
//  Created by Pete West on 2022/04/05.
//

import SwiftUI

protocol EditFishViewModelProtocol {
    func editFish(completion: @escaping
        (Result<Fish, Error>) -> Void)
    func deleteFish(completion: @escaping
        (Result<Fish, Error>) -> Void )
}

final class EditFishViewModel: ObservableObject {
    @Published var species: String
    @Published var weight: Double
    @Published var length: Double
    @Published var releaseStatus: ReleaseStatus
    @Published var timeCaught: Date
    @Published var fightDuration: Double
    @Published var image: UIImage?

    var fish: Fish

    let service = FishService.shared
    @Published private(set) var state: LoadingState<Fish> = LoadingState.idle
    init(fish: Fish) {
        state = .loaded(fish)
        self.fish = fish
        species = fish.species ?? "ErrorWriting:Species"
        weight = fish.weight ?? -1
        length = fish.length ?? -1
        releaseStatus = fish.releaseStatus.unsafelyUnwrapped
        timeCaught = fish.timeCaught.unsafelyUnwrapped
        fightDuration = fish.fightDuration.unsafelyUnwrapped
    }
}

extension EditFishViewModel: EditFishViewModelProtocol {
    func editFish(completion: @escaping
        (Result<Fish, Error>) -> Void = { _ in })
    {
        self.state = .loading
        let updated = Fish(id: fish.id,
                           owner: fish.owner,
                           trip: fish.trip,
                           species: species,
                           weight: weight,
                           length: length,
                           releaseStatus: releaseStatus,
                           timeCaught: timeCaught,
                           fightDuration: fightDuration,
                           attractant: .none,
                           attractantDetail: .none,
                           notes: "Medium",
                           image: fish.image,
                           createdAt: fish.createdAt,
                           updatedAt: Date())
        FishService.shared.editFish(fish: updated) { result in
            switch result {
                case .success:
                    self.state = .loaded(self.fish)
                    completion(.success(self.fish))
                case .failure(let error):
                    self.state = .failed(error)
                    completion(.failure(error))
            }
        }
    }

    func deleteFish(completion: @escaping
        (Result<Fish, Error>) -> Void = { _ in })
    {
        self.state = .loading
        FishService.shared.deleteFish(fish: fish) { result in
            switch result {
                case .success(let fish):
                    self.state = .loaded(fish)
                case .failure(let error):
                    self.state = .failed(error)
            }
        }
    }
}
