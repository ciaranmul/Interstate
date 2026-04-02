//
//  InterstateApp.swift
//  Interstate
//
//  Created by Ciarán Mulholland on 21/03/2026.
//

import SwiftUI
import SwiftData

@main
struct InterstateApp: App {
    var sharedModelContainer: ModelContainer = {
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
        }
        .modelContainer(sharedModelContainer)

        #if os(macOS)
        MenuBarExtra("Interstate High Speed",
                     systemImage: "pencil.circle.fill") {
            MenuBarView()
        }
        .menuBarExtraStyle(.window)
        .modelContainer(sharedModelContainer)
        #endif
    }
}
