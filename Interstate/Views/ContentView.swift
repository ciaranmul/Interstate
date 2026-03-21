//
//  ContentView.swift
//  Interstate
//
//  Created by Ciarán Mulholland on 21/03/2026.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationSplitView {
            ProjectsList()
                .navigationTitle("Projects")
                #if os(macOS)
                .navigationSplitViewColumnWidth(min: 180, ideal: 200)
                #endif
                .toolbar {
                    #if os(iOS)
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                    #endif
                    ToolbarItem {
                        Button(action: addItem) {
                            Label("New Project", systemImage: "plus")
                        }
                    }
                }
        } detail: {
            ContentUnavailableView("Select a project.", systemImage: "pencil", description: Text("Use '+' to add a new project if you don't see any."))
        }
    }

    private func addItem() {
        withAnimation {
            let newProject = Project()
            modelContext.insert(newProject)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
