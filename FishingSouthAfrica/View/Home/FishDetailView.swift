//
//  FishCaughtDetailView.swift
//  FishingSouthAfrica
//
//  Created by Pete West on 2022/04/04.
//

import SDWebImageSwiftUI
import SwiftUI

struct FishDetailView: View {
    @ObservedObject var viewModel: FishDetailViewModel
    @State private var isShowingEdit = false

    var body: some View {
        switch viewModel.state {
            case .idle:
                Color.clear.onAppear {
                    //Do smeotinh
                }
            case .loading:
                ProgressView()
            case .failed(let error):
                ErrorView(error: error)
            case .loaded(_):
                loadedView
        }
    }
    
    private var loadedView: some View {
        Group {
            VStack {
                if let image = viewModel.fish.image {
                    WebImage(url: URL(string: image)).resizable().frame(height: 200, alignment: .center)
                }
                Text("Species: \(viewModel.fish.species.unsafelyUnwrapped)")
                Text("Weight: \(viewModel.fish.weight.unsafelyUnwrapped)")
                Text("Length: \(viewModel.fish.length.unsafelyUnwrapped)")
                Spacer()

                
            }
        }.sheet(isPresented: $isShowingEdit, onDismiss: nil) {
            EditFishView(viewModel: EditFishViewModel(fish: viewModel.fish))
        }.navigationBarTitle(Text(viewModel.fish.species ?? "Fishname")).navigationBarItems(trailing: editButton)
    }

    private var editButton: some View {
        Button(action: {
            self.isShowingEdit.toggle()
        }) {
            Text("Edit")
        }
    }
}
