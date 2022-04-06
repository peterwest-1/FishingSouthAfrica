//
//  SettingsViewModel.swift
//  FishingSouthAfrica
//
//  Created by Pete West on 2022/04/06.
//

import Foundation
import FirebaseAuth

protocol SettingsViewModelProtocol {
    func updateUserInfo(name: String)
}

final class SettingsViewModel: ObservableObject {
//    @Published var _
    
    init(){
        
    }
}

extension SettingsViewModel: SettingsViewModelProtocol {
    func updateUserInfo(name: String) {
        let user  = Auth.auth().currentUser?.createProfileChangeRequest()
        user?.displayName = name
        user?.commitChanges(completion: { error in
            if let err = error {
                print(err)
            }
        })
    }
}




