//
//  InterstateApp.swift
//  Interstate
//
//  Created by Ciarán Mulholland on 21/03/2026.
//

import AppIntents
import SwiftUI
import SwiftData

@main
struct InterstateApp: App {
    @State private var appModel: AppModel

    init() {
        self.appModel = .init(modelContext: .init(sharedModelContainer))
        let data = appModel
        AppDependencyManager.shared.add(dependency: data)
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

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appModel)
        }
        .handlesExternalEvents(matching: [
            AddEntryIntent.persistentIdentifier
        ])

        #if os(macOS)
        MenuBarExtra("Interstate High Speed",
                     systemImage: "pencil.circle.fill") {
            MenuBarView()
                .environment(appModel)
        }
        .menuBarExtraStyle(.window)
        #endif
    }
}

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
