//
//  FishingOutingListItem.swift
//  Fishing South Africa
//
//  Created by Pete West on 2022/01/01.
//

import SwiftUI

struct TripListItem: View {
    var trip: Trip

    var body: some View {
        VStack(alignment: .leading) {
            Text(trip.name ?? "Trip Name").font(.headline)
            Text(trip.locationName ?? "Trip Location")
            Text(trip.dateStart ?? Date(), formatter: DateFormatters.longNoneDateFormatter)
            Divider()
            Text("Fish Caught: \(trip.fish?.count ?? -1)")
        }
    }
}
