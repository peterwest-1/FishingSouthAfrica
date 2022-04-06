//
//  EditFishCaughtViewModel.swift
//  FishingSouthAfrica
//
//  Created by Pete West on 2022/04/05.
//

import SwiftUI

protocol EditFishViewModelProtocol {
    func editFish()
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

    init(fish: Fish) {
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
    func editFish() {
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
        FishService.shared.editFish(fish: updated)
    }
}
