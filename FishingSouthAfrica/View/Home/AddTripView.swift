//
//  CreateFishCaughtView.swift
//  Fishing South Africa
//
//  Created by Pete West on 2022/01/01.
//

import CoreLocationUI
import FirebaseAuth
import MapKit
import SwiftUI

struct AddTripView: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @StateObject var viewModel = AddTripViewModel()
    @StateObject var locationManager = LocationManager()

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Trip Name", text: $viewModel.name)
                    TextField("Location", text: $viewModel.locationName)
                }

                Section(header: Text("Date")) {
                    DatePicker("Starting Time", selection: $viewModel.dateStart)
                    DatePicker("Ending Time", selection: $viewModel.dateFinish)
                }

                Section(header: Text("Save")) {
                    Button("Save") {
                        viewModel.addTrip()
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
            }.navigationTitle("Fishing Trip")
        }
    }
}
