//
//  ProjectDetailsView.swift
//  Interstate
//
//  Created by Ciarán Mulholland on 22/03/2026.
//

import SwiftData
import SwiftUI

struct ProjectDetailsView: View {
    @Bindable var project: Project
    @State private var selectedItem: Item? = nil
    @State private var showingAlert: Bool = false

    var body: some View {
        Group {
            if let items = project.items, !items.isEmpty {
                List {
                    ForEach(items.sorted(by: {
                        $0.timestamp.compare($1.timestamp) == .orderedAscending
                    })) { item in
                        let date = Date.FormatStyle(date: .omitted, time: .shortened).format(item.timestamp)
                        let text = item.entry.isEmpty ? "[No description]" : item.entry

                        Button {
                            selectedItem = item
                        } label: {
                            Text("\(date): \(text)")
                        }
                        .buttonStyle(.plain)
                    }
                    .onDelete(perform: deleteItems)
                }
            } else {
                ContentUnavailableView("You have no entries, yet.", systemImage:"text.document", description: Text("Use the '+' to add a new entry. Tip: you can press 'Return' on your keyboard to add a new entry."))
            }
        }
        .toolbar {
            #if os(iOS)
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
            #else
            ToolbarItem {
                Button(action: renameProject) {
                    Label("Rename project", systemImage: "pencil")
                }
            }
            #endif
            ToolbarItem {
                Button(action: addItem) {
                    Label("Add Item", systemImage: "plus")
                }
                .keyboardShortcut(.defaultAction)
            }
        }
        .navigationTitle($project.title)
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .sheet(item: $selectedItem) { item in
            NavigationStack {
                ItemDetailsView(item: item)
            }
        }
        .alert("Rename project", isPresented: $showingAlert) {
            TextField("New project name", text: $project.title)
            Button("OK") { }
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item()
            project.items?.append(newItem)
            selectedItem = newItem
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                project.items?.remove(at: index)
            }
        }
    }

    private func renameProject() {
        showingAlert = true
    }
}
