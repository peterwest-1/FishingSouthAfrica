//
//  FishCaught.swift
//  Fishing South Africa
//
//  Created by Pete West on 2022/01/01.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Fish: Codable {
    var id: UUID
    var owner: String
    var trip: String
    
    var species: String?
    var weight: Double?
    var length: Double?
    var releaseStatus: ReleaseStatus?
    
    var timeCaught: Date?
    // TODO: - Add proper way of getting fight duration
    var fightDuration: Double?
    
    var attractant: Attractant?
    var attractantDetail: String?
    
    var notes: String?
    
    var image: String?
    
    var createdAt: Date?
    var updatedAt: Date?
    
    var UUID: String {
        return id.uuidString
    }

}

enum Attractant: Codable {
    case Bait
    case Lure
    case Fly
}

enum ReleaseStatus: String, Codable {
    case Released = "Released"
    case Kept = "Kept"
}
