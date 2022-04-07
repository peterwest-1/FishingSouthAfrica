//
//  CreateFishCaughtView.swift
//  Fishing South Africa
//
//  Created by Pete West on 2022/01/01.
//

import Combine
import FirebaseAuth
import SwiftUI

struct AddFishView: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>

    @ObservedObject var viewModel: AddFishViewModel

    @State private var showingFightDuration = false
    @State private var showingImagePicker = false
    @State private var shouldPresentImagePicker = false
    @State private var shouldPresentActionScheet = false
    @State private var shouldPresentCamera = false
    @State private var image: UIImage?

    var body: some View {
        switch viewModel.state {
        case .idle:
            ProgressView()
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
                Section(header: Text("Info")) {
                    if #available(iOS 15.0, *) {
                        TextField(text: $viewModel.species, prompt: Text("Species")) {
                            Text("Species")
                        }
                        TextField("Weight", value: $viewModel.weight, formatter: NumberFormatters.decimalTwoNumberFormatter, prompt: Text("Weight"))
                            .keyboardType(.decimalPad)

                        TextField("Length", value: $viewModel.length, formatter: NumberFormatters.decimalTwoNumberFormatter, prompt: Text("Length"))
                    } else {
                        // Fallback on earlier versions
                    }
                }

                Section(header: Text("Location")) {
                    NavigationLink {
//                    FishCaughtMap()
                    } label: {
                        Text("Add Location")
                    }

                }.disabled(true)

                Section(header: Text("Fight Info")) {
                    Picker("Released", selection: $viewModel.releaseStatus) {
                        Text("Released").tag(ReleaseStatus.Released)
                        Text("Kept").tag(ReleaseStatus.Kept)
                    }.pickerStyle(.segmented)
                    DatePicker("Date Caught", selection: $viewModel.timeCaught, displayedComponents: .hourAndMinute)
                }

                Section(header: Text("Picture")) {
                    HStack {
                        Button(action: {
                            CameraManager.requestCameraAccess()
                            self.shouldPresentActionScheet = true
                        }, label: {
                            HStack {
                                Text("Open Camera")
                                Spacer()
                                Image(systemName: "camera.on.rectangle.fill")
                            }
                        })
                    }
                    if let image = self.image {
                        Image(uiImage: image)
                    }
                }

            }.navigationTitle("Add Fish").sheet(isPresented: $shouldPresentImagePicker) {
                ImagePickerView(sourceType: self.shouldPresentCamera ? .camera : .photoLibrary, image: self.$viewModel.image, isPresented: self.$shouldPresentImagePicker)
            }.actionSheet(isPresented: $shouldPresentActionScheet) { () -> ActionSheet in
                CameraLibraryActionSheet()
            }.navigationBarItems(leading: cancelButton, trailing: saveButton)
        }
    }

    private var saveButton: some View {
        Button {
            self.viewModel.addFish { result in
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

    private func CameraLibraryActionSheet() -> ActionSheet {
        return ActionSheet(title: Text("Choose Mode"), message: Text("Please choose your preferred mode to set fish"), buttons: [ActionSheet.Button.default(Text("Camera"), action: {
            self.shouldPresentImagePicker = true
            self.shouldPresentCamera = true
        }), ActionSheet.Button.default(Text("Photo Library"), action: {
            self.shouldPresentImagePicker = true
            self.shouldPresentCamera = false
        }), ActionSheet.Button.cancel()])
    }
}
