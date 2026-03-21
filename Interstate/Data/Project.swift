//
//  Project.swift
//  Interstate
//
//  Created by Ciarán Mulholland on 22/03/2026.
//

import Foundation
import SwiftData

@Model
final class Project {
    var id = UUID()
    var title: String
    @Relationship(deleteRule: .cascade) var items: [Item]

    init(title: String = "New Project", items: [Item] = []) {
        self.title = title
        self.items = items
    }
}
