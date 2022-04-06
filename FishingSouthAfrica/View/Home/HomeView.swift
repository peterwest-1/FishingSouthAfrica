//
//  HomeView.swift
//  FishingSouthAfrica
//
//  Created by Pete West on 2022/03/30.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel = HomeViewModel()

    @State private var editMode = EditMode.inactive
    @State private var isShowingAddNew = false

    var body: some View {
        switch viewModel.state {
        case .idle:
            Color.clear.onAppear {
                viewModel.fetchTrips()
            }
        case .loading:
            ProgressView()
        case .failed(let error):
            ErrorView(error: error)

        case .loaded(let trips):
            NavigationView {
                Group {
                    if !viewModel.trips.isEmpty {
                        VStack {
                            List {
                                ForEach(trips, id: \.id) { trip in
                                    NavigationLink(
                                        destination: TripDetailView(viewModel: TripDetailViewModel(trip: trip)),
                                        label: {
                                            TripListItem(trip: trip)
                                        })
                                }.onDelete(perform: onDelete)
                            }

                        }.navigationBarTitle(Text("Trips"))
                            .navigationBarItems(leading: EditButton(), trailing: addNewButton)
                            .environment(\.editMode, $editMode)
                    }
                    else {
                        Group {
                            Text("No Fishing Trips").font(.system(size: 20)).bold()
                            Text("Add a trip with the \'+\'").font(.system(size: 16))
                        }.navigationBarTitle(Text("Trips"))
                            .navigationBarItems(trailing: addNewButton)
                            .environment(\.editMode, $editMode)
                    }

                }.sheet(isPresented: $isShowingAddNew, onDismiss: {
                    self.viewModel.fetchTrips()
                }) {
                    AddTripView()
                }
            }
        }
    }

    private var addNewButton: some View {
        Button(action: {
            self.isShowingAddNew.toggle()
        }) {
            Image(systemName: "plus")
        }
    }

    private func onDelete(offsets: IndexSet) {
        let trip = viewModel.trips[offsets.first!]
        viewModel.deleteTrip(trip: trip)
        viewModel.fetchTrips()
        print("delete")
    }
}
