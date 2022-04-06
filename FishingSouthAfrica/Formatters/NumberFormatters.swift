//
//  NumberFormatters.swift
//  FishingSouthAfrica
//
//  Created by Pete West on 2022/04/04.
//

import Foundation

struct NumberFormatters {
    static let decimalTwoNumberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter
    }()
}
