//
//  MenuBarProjectsList.swift
//  Interstate
//
//  Created by Ciarán Mulholland on 02/04/2026.
//

import SwiftData
import SwiftUI

@available(macOS 26, *)
struct MenuBarProjectsList: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var projects: [Project]

    var body: some View {
        List {
            ForEach(projects) { project in
                NavigationLink {
                    MenuBarProjectDetailsView(project: project)
                } label: {
                    Text(project.title)
                }
            }
        }
    }
}

@available(macOS 26, *)
struct MenuBarProjectDetailsView: View {
    @Bindable var project: Project
    @FocusState private var selectedItemId: UUID?

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
                VStack {
                    list
                    Button {
                        addItem()
                    } label: {
                        Image(systemName: "plus")
                    }
                    .keyboardShortcut(.defaultAction)
                }
            }
        }
        .padding()
        .navigationTitle($project.title)
    }

    @ViewBuilder
    private var emptyStateView: some View {
        ContentUnavailableView("You have no entries, yet.",
                               systemImage:"text.document",
                               description: Text("Use the '+' to add a new entry. Tip: you can press 'Return' on your keyboard to add a new entry."))
    }

    @ViewBuilder
    private var list: some View {
        List() {
            ForEach(dates, id: \.self) { date in
                Section("\(date.formatted(date: .abbreviated, time: .omitted))") {
                    ForEach(items(for: date), id: \.self) { item in
                        ListItem(item: item)
                            .tag(item.id)
                            .focused($selectedItemId, equals: item.id)
                    }
                    .onDelete { indexSet in
                        deleteItems(offsets: indexSet, date: date)
                    }
                }
            }
        }
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
            selectedItemId = newItem.id
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
}

struct ListItem: View {
    @State var item: Item

    var date: String { Date.FormatStyle(date: .omitted, time: .shortened).format(item.timestamp) }

    var body: some View {
        HStack {
            Text(date)
            TextField("Description", text: $item.entry)
            Spacer()
        }
    }
}
