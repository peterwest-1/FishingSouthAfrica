//
//  FishCaughtDetailViewModel.swift
//  FishingSouthAfrica
//
//  Created by Pete West on 2022/04/04.
//

import Foundation
import SwiftUI

protocol FishDetailViewModelProtocol {
    
}

final class FishDetailViewModel: ObservableObject {
    var fish: Fish
    
    @Published var image: UIImage?
    let service = FishService.shared
    
    @Published private(set) var state: LoadingState<Fish> = LoadingState.idle
    
    init(fish: Fish){
        self.state = .loaded(fish)
        self.fish = fish
        
    }
}

extension FishDetailViewModel: FishDetailViewModelProtocol {

    

}


