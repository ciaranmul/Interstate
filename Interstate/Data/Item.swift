//
//  Item.swift
//  Interstate
//
//  Created by Ciarán Mulholland on 21/03/2026.
//

import Foundation
import SwiftData

@Model
final class Item {
    var id = UUID()
    var timestamp: Date
    var entry: String

    init(timestamp: Date = .now,
         description: String = "New item") {
        self.timestamp = timestamp
        self.entry = description
    }
}
