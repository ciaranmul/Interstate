//
//  ProjectsList.swift
//  Interstate
//
//  Created by Ciarán Mulholland on 22/03/2026.
//

import SwiftData
import SwiftUI

struct ProjectsList: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var projects: [Project]

    var body: some View {
        List {
            ForEach(projects) { project in
                NavigationLink {
                    ProjectDetailsView(project: project)
                } label: {
                    Text(project.title)
                }
            }
            .onDelete(perform: deleteItems)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(projects[index])
            }
        }
    }
}
