//
//  FishingSouthAfricaApp.swift
//  FishingSouthAfrica
//
//  Created by Pete West on 2022/03/30.
//

import SwiftUI
import Firebase
@main
struct FishingSouthAfricaApp: App {
    var authentication = Authentication()
    init() {
        FirebaseApp.configure()
      
     }
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(authentication)
        }
    }
}
