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
    @State private var selectedListItem: Item? = nil
    @State private var showingAlert: Bool = false

    var items: [Item] {
        project.items ?? []
    }

    var groupedItems: [Date: [Item]] {
        Dictionary(grouping: items) { item in
            Calendar.current.startOfDay(for: item.timestamp)
        }
    }

    var dates: [Date] {
        Array(groupedItems.keys).sorted(by: {
            $0.compare($1) == .orderedAscending
        })
    }

    var body: some View {
        Group {
            if items.isEmpty {
                emptyStateView
            } else {
                list
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
                .keyboardShortcut(.init("r"))
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

    @ViewBuilder
    private var emptyStateView: some View {
        ContentUnavailableView("You have no entries, yet.",
                               systemImage:"text.document",
                               description: Text("Use the '+' to add a new entry. Tip: you can press 'Return' on your keyboard to add a new entry."))
    }

    @ViewBuilder
    private var list: some View {
        List(selection: $selectedListItem) {
            ForEach(dates, id: \.self) { date in
                Section("\(date.formatted(date: .abbreviated, time: .omitted))") {
                    ForEach(items(for: date), id: \.self) { item in
                        listItem(for: item)
                            .tag(item)
                    }
                    .onDelete { indexSet in
                        deleteItems(offsets: indexSet, date: date)
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func listItem(for item: Item) -> some View {
        let date = Date.FormatStyle(date: .omitted, time: .shortened).format(item.timestamp)
        let text = item.entry.isEmpty ? "[No description]" : item.entry

        Button {
            selectedItem = item
        } label: {
            Text("\(date): \(text)")
        }
        .buttonStyle(.plain)
    }

    private func items(for date: Date) -> [Item] {
        (groupedItems[date] ?? []).sorted(by: {
            $0.timestamp.compare($1.timestamp) == .orderedAscending
        })
    }

    private func addItem() {
        withAnimation {
            let newItem = Item()
            project.items?.append(newItem)
            selectedItem = newItem
        }
    }

    private func deleteItems(offsets: IndexSet, date: Date) {
        let ids = offsets.map { items(for: date)[$0].id }
        for id in ids {
            withAnimation {
                project.items?.removeAll { $0.id == id }
            }
        }
    }

    private func renameProject() {
        showingAlert = true
    }
}

#Preview {
    ProjectDetailsView(project: .init())
}
