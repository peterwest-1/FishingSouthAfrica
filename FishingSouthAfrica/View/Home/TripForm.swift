//
//  TripForm.swift
//  FishingSouthAfrica
//
//  Created by Pete West on 2022/04/06.
//

import SwiftUI

struct TripForm: View {
    var name: Binding<String>
    var locationName: Binding<String>

    var dateStart: Binding<Date>
    var dateFinish: Binding<Date>

    init(
        name: Binding<String>,
        locationName: Binding<String>,
        dateStart: Binding<Date>,
        dateFinish: Binding<Date>
    ) {
        self.name = name
        self.locationName = locationName
        self.dateStart = dateStart
        self.dateFinish = dateFinish
    }

    var body: some View {
        Section {
            TextField("Trip Name", text: name)
            TextField("Location", text: locationName)
        }

        Section(header: Text("Date")) {
            DatePicker("Starting", selection: dateStart)
            DatePicker("Ending", selection: dateFinish)
        }
    }
}
