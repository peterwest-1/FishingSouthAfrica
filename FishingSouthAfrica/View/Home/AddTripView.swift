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
        switch viewModel.state {
        case .idle:
            Color.clear.onAppear {}
        case .loading:
            ProgressView()
        case .failed(let error):
            ErrorView(error: error)

        case .loaded:
            loadedView
        }
    }

    private var loadedView: some View {
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

            }.navigationTitle("Fishing Trip").navigationBarItems(leading: cancelButton, trailing: saveButton)
        }
    }

    private var saveButton: some View {
        Button {
            self.viewModel.addTrip() { result in
                switch result {
                case .success:
                    self.presentationMode.wrappedValue.dismiss()
                case .failure(let error):
                    print(error)
                }
            }
        } label: {
            Text("Save")
        }
    }

    private var cancelButton: some View {
        Button {
            self.presentationMode.wrappedValue.dismiss()
        } label: {
            Text("Cancel").foregroundColor(.red)
        }
    }
}
