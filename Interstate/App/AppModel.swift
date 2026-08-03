//
//  AppModel.swift
//  Interstate
//
//  Created by Ciarán Mulholland on 02/08/2026.
//

import SwiftData
import SwiftUI

@Observable
class AppModel {
    let modelContext: ModelContext
    var projects: [Project]
    var error: Error?

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        self.projects = []
    }

    func fetchData() {
        do {
            let descriptor = FetchDescriptor<Project>(sortBy: [SortDescriptor(\.title)])
            projects = try modelContext.fetch(descriptor)
        } catch {
            self.error = error
        }
    }

    func delete(_ project: Project) {
        defer {
            fetchData()
        }

        modelContext.delete(project)
    }

    func add(_ project: Project) {
        defer {
            fetchData()
        }

        modelContext.insert(project)
    }

    private var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Project.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
}
