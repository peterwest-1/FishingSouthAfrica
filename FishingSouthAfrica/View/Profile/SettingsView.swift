//
//  SettingsView.swift
//  FishingSouthAfrica
//
//  Created by Pete West on 2022/04/06.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @AppStorage("name") var name = DefaultSettings.name
    @AppStorage("location") var location = DefaultSettings.location
    @AppStorage("bio") var bio = DefaultSettings.bio
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Profile")) {
                    Button(
                        action: {
                            // Action
                        },
                        label: {
                            Text("Pick Profile Image")
                        }
                    )
                    TextField("Name", text: $name)
                    TextField("Subtitle", text: $location)
                    TextEditor(text: $bio)
                }
            }
            .navigationBarTitle(Text("Settings"))
            .navigationBarItems(
                trailing:
                Button(
                    action: {
                        self.presentationMode.wrappedValue.dismiss()
                    },
                    label: {
                        Text("Done")
                    }
                )
            )
        }
    }
}
