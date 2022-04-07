//
//  AddFishCaughtViewModel.swift
//  FishingSouthAfrica
//
//  Created by Pete West on 2022/04/03.
//

import FirebaseAuth
import SwiftUI

protocol AddFishViewModelProtocol {
    func addFishCaught()
}

final class AddFishViewModel: ObservableObject {
    @Published var species: String = ""
    @Published var weight: Measurement<UnitMass>
    @Published var length: Measurement<UnitLength>
    @Published var releaseStatus = ReleaseStatus.Released
    @Published var timeCaught = Date()
    @Published var fightDuration: Measurement<UnitDuration>
    @Published var image: UIImage?

    var trip: Trip

    init(trip: Trip) {
        self.trip = trip
        self.weight = Measurement<UnitMass>(value: 0.0, unit: .kilograms)
        self.length = Measurement<UnitLength>(value: 0.0, unit: .centimeters)
        self.fightDuration = Measurement<UnitDuration>(value: 0.0, unit: .minutes)
    }
}

extension AddFishViewModel: AddFishViewModelProtocol {
//    private func addFish(fish: Fish) {
//        service.addFishCaught(fish: fish) {
//            self.service.addFishCaughtToTrip(trip: self.trip, fish: fish) {
//                self.service.addFishCaughtToUser(fish: fish) {
//                    print("Success")
//                }
//            }
//        }
//    }

    func addFishCaught() {
        let currentUserUID = Auth.auth().currentUser?.uid ?? "-5"

        var fish = Fish(id: UUID(),
                        owner: currentUserUID,
                        trip: trip.UUID,
                        species: species,
                        weight: weight.value,
                        length: length.value,
                        releaseStatus: releaseStatus,
                        timeCaught: timeCaught,
                        fightDuration: fightDuration.value,
                        attractant: .none,
                        attractantDetail: .none,
                        notes: "Medium",
                        image: nil,
                        createdAt: Date(),
                        updatedAt: Date())

        FishService.shared.addFish(fish: fish, trip: trip, completion: { result in
            switch result {
                case .success:
                    if let img = self.image {
                        FishService.shared.uploadFishImage(image: img, fish: fish) { url in
                            fish.image = url
                        }
                    }
                case .failure(let error):
                    print(error)
            }
        })
    }
}
