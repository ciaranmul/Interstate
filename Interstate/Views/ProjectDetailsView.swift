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
        List {
            ForEach(project.items) { item in
                let date = Date.FormatStyle(date: .omitted, time: .shortened).format(item.timestamp)
                let text = item.entry.isEmpty ? "[No description]" : item.entry

                Button {
                    selectedItem = item
                } label: {
                    Text("\(date): \(text)")
                }
            }
            .onDelete(perform: deleteItems)
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
            project.items.append(newItem)
            selectedItem = newItem
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                project.items.remove(at: index)
            }
        }
    }

    private func renameProject() {
        showingAlert = true
    }
}
