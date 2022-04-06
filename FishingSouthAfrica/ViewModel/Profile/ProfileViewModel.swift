//
//  ProfileViewModel.swift
//  FishingSouthAfrica
//
//  Created by Pete West on 2022/04/04.
//

import Foundation
import FirebaseAuth

protocol ProfileViewModelProtocol {
    func fetchUser()
}

final class ProfileViewModel: ObservableObject {
    @Published var user: User?
    
    init(){
       fetchUser()
    }
}

extension ProfileViewModel: ProfileViewModelProtocol {
    func fetchUser() {
        self.user = Auth.auth().currentUser
    }
}


