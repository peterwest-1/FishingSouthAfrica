//
//  DateFormatter.swift
//  FishingSouthAfrica
//
//  Created by Pete West on 2022/04/04.
//

import SwiftUI

struct DateFormatters {
    static let longNoneDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        return dateFormatter
    }()
}
