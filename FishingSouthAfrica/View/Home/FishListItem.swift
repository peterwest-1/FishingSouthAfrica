//
//  FishCaughtListItem.swift
//  FishingSouthAfrica
//
//  Created by Pete West on 2022/04/04.
//

import SwiftUI
import SDWebImageSwiftUI

struct FishListItem: View {
    var fish: Fish
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(fish.species ?? "species").font(.headline)
            Text(fish.timeCaught ?? Date(), formatter: DateFormatters.longNoneDateFormatter)
            if let image = fish.image {
                WebImage(url: URL(string: image)).resizable().frame(height: 200, alignment: .center)
            }
            
        }
    }
}
