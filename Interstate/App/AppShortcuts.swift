//
//  AppShortcuts.swift
//  Interstate
//
//  Created by Ciarán Mulholland on 01/08/2026.
//

import AppIntents

struct AppShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(intent: AddEntryIntent(),
                    phrases: [
                        "Add a new entry in \(.applicationName)",
                        "Add a new entry for \(\.$project) in \(.applicationName)"
                    ],
                    shortTitle: "Add Entry",
                    systemImageName: "pencil")
    }
}
