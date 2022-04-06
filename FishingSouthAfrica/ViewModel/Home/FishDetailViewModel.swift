//
//  FishCaughtDetailViewModel.swift
//  FishingSouthAfrica
//
//  Created by Pete West on 2022/04/04.
//

import Foundation
import SwiftUI

protocol FishDetailViewModelProtocol {
    func getImage()
}

final class FishDetailViewModel: ObservableObject {
    var fish: Fish
    
    @Published var image: UIImage?
    let service = FishService.shared
    
    
    init(fish: Fish){
        self.fish = fish
        getImage()
        
    }
}

extension FishDetailViewModel: FishDetailViewModelProtocol {
    func getImage(){
       
        service.getImage(fish: self.fish) { image in
            self.image = image ?? UIImage(named: "profile")
        }
    }
    

}


