//
//  CreateFishCaughtView.swift
//  Fishing South Africa
//
//  Created by Pete West on 2022/01/01.
//

import Combine
import FirebaseAuth
import SwiftUI

struct EditFishView: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>

    @ObservedObject var viewModel: EditFishViewModel

    @State private var showingFightDuration = false
    @State private var showingImagePicker = false
    @State private var shouldPresentImagePicker = false
    @State private var shouldPresentActionScheet = false
    @State private var shouldPresentCamera = false
    @State private var image: UIImage?

    var body: some View {
        switch viewModel.state {
            case .idle:
                EmptyView()
            case .loading:
                ProgressView()
            case .failed(let error):
                ErrorView(error: error)
            case .loaded(_):
                idleView
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
    
    private var idleView: some View {
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
                    Toggle(isOn: $showingFightDuration) {
                        Text("Add Fight Duration")
                    }
                    //                if showingFightDuration {
                    //                    TimeDurationPicker(duration: $viewModel.fightDuration).pickerStyle(.inline)
                    //                }
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
                Section {
                    deleteButton
                }
            }.navigationTitle(viewModel.fish.species ?? "Name")
                .sheet(isPresented: $shouldPresentImagePicker) {
                    ImagePickerView(sourceType: self.shouldPresentCamera ? .camera : .photoLibrary, image: self.$viewModel.image, isPresented: self.$shouldPresentImagePicker)
                }
                .actionSheet(isPresented: $shouldPresentActionScheet) { () -> ActionSheet in
                    CameraLibraryActionSheet()
                }.navigationBarItems(leading: cancelButton, trailing: saveButton)
        }
    }

    private var saveButton: some View {
        Button {
            self.viewModel.editFish { result in
                switch result {
                    
                    case .success:
                        print("Dismisssssss")
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

    private var deleteButton: some View {
        Button {
            viewModel.deleteFish { result in
                switch result {
                    case .success:
                        self.presentationMode.wrappedValue.dismiss()
                    case .failure(let error):
                        print(error)
                }
            }

        } label: {
            Text("Delete Fish").foregroundColor(.red)
        }
    }
}
