//
//  FishingOutingDetailView.swift
//  Fishing South Africa
//
//  Created by Pete West on 2022/01/01.
//

import SwiftUI

struct TripDetailView: View {
    @ObservedObject var viewModel: TripDetailViewModel
    @State private var isShowingAddFish = false
    @State private var isShowingEditTrip = false

    private var addFishButton: some View {
        Button(action: {
            self.isShowingAddFish.toggle()
        }) {
            Image(systemName: "plus")
        }
    }

    var body: some View {
        switch viewModel.state {
        case .idle:
            Color.clear.onAppear {
                viewModel.fetchFish()
            }
        case .loading:
            ProgressView()
        case .failed:
            ProgressView()
        case .loaded(let fishes):
            Group {
                if !fishes.isEmpty {
                    VStack {
                        List {
                            ForEach(fishes, id: \.id) { fish in
                                NavigationLink(
                                    destination: FishDetailView(viewModel: FishDetailViewModel(fish: fish)),
                                    label: {
                                        FishListItem(fish: fish)
                                    })
                            }.onDelete(perform: onDelete)
                        }
                        Button {
                            self.isShowingEditTrip.toggle()
                        } label: {
                            Text("Edit Trip")
                        }.buttonStyle(MyButtonStyle())
                    }
                }
                else {
                    Group {
                        Text("No Fish").font(.system(size: 20)).bold()
                        Text("Add a fish with the \'+\'").font(.system(size: 16))
                    }
                }
            }.sheet(isPresented: $isShowingAddFish, onDismiss: {
                self.viewModel.fetchFish()
            }) {
                AddFishView(viewModel: AddFishViewModel(trip: self.viewModel.trip))
            }.sheet(isPresented: $isShowingEditTrip, onDismiss: {
                self.viewModel.fetchFish()
            }) {
                EditTripView(viewModel: EditTripViewModel(trip: self.viewModel.trip))
            }.navigationBarTitle(Text(viewModel.trip.name ?? "Trip Name")).navigationBarItems(trailing: addFishButton)
        }
    }

    private func onDelete(offsets: IndexSet) {
//        let trip = viewModel.trips[offsets.first!]
//        viewModel.deleteTrip(trip: trip)
//        viewModel.fetchTrips()
        print("delete")
    }
}
