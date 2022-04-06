//
//  ErrorView.swift
//  FishingSouthAfrica
//
//  Created by Pete West on 2022/04/03.
//

import SwiftUI

struct ErrorView: View {
    var error: Error
    var body: some View {
        Text(error.localizedDescription)
    }
}
