//
//  EditTripView.swift
//  FishingSouthAfrica
//
//  Created by Pete West on 2022/04/06.
//

import SwiftUI

struct EditTripView: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>

    @ObservedObject var viewModel: EditTripViewModel

    @StateObject var locationManager = LocationManager()

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Trip Name", text: $viewModel.name)
                    TextField("Location", text: $viewModel.locationName)
                }

                Section(header: Text("Date")) {
                    DatePicker("Start", selection: $viewModel.dateStart)
                    DatePicker("End", selection: $viewModel.dateFinish)
                }
            }.navigationTitle("Fishing Trip").navigationBarItems(leading: cancelButton, trailing: saveButton)
        }
    }

    private var saveButton: some View {
        Button {
            self.viewModel.editTrip()
            self.presentationMode.wrappedValue.dismiss()
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
