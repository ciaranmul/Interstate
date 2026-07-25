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
    var id: UUID = UUID()
    var project: Project?
    var timestamp: Date = Date.now
    var entry: String = ""

    init(timestamp: Date = .now,
         description: String = "") {
        self.timestamp = timestamp
        self.entry = description
    }
}
