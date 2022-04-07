//
//  FishingOuting.swift
//  Fishing South Africa
//
//  Created by Pete West on 2022/01/01.
//

import Foundation
import CoreLocation

struct Trip: Codable {
    var id: UUID
    var owner: String
    
    var name: String?
    
    var dateStart: Date?
    var dateFinish: Date?
    
    var latitude: Double?
    var longitude: Double?
    var locationName: String?
    
    var friends: [String]?
    
    var fish: [String]?
    
    //TODO: - Fix to actually use Image data and not Image View
    var images: [String]?
    
    var createdAt: Date?
    var updatedAt: Date?
    
    
    var UUID: String {
        return id.uuidString
    }
}

