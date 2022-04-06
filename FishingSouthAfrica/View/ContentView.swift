//
//  ContentView.swift
//  FishingSouthAfrica
//
//  Created by Pete West on 2022/03/30.
//

import FirebaseAuth
import SwiftUI

struct ContentView: View {
    @AppStorage("authentication") var status = false

    init() {
        if Auth.auth().currentUser == nil {
            @AppStorage("authentication") var status = false
        }
    }

    var body: some View {
        Group {
            if status {
                TabView {
                    HomeView().tabItem {
                        Label("Home", systemImage: "house")
                    }
                    RegulationsView().tabItem {
                        Label("Regs", systemImage: "book")
                    }
                    ProfileView().tabItem {
                        Label("Profile", systemImage: "person")
                    }
                }
            } else {
                LoginView()
            }
        }
    }
}
