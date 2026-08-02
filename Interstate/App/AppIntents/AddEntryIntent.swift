//
//  AddEntryIntent.swift
//  Interstate
//
//  Created by Ciarán Mulholland on 01/08/2026.
//

import AppIntents

struct AddEntryIntent: AppIntent {
    static let title: LocalizedStringResource = "Add Entry"

    @Dependency var appModel: AppModel

    @Parameter(title: "Project", requestValueDialog: "Which project?")
    var project: ProjectEntity

    @Parameter(title: "Entry")
    var entry: String

    @MainActor func perform() async throws -> some IntentResult {
        appModel.projects.first { $0.id.uuidString == project.id }?.items?.append(.init(description: entry))
        return .result()
    }
}
