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
    @State private var selectedProject: Project? = nil
    @State private var confirmDelete: Bool = false
    @Query private var projects: [Project]

    var body: some View {
        List(selection: $selectedProject) {
            ForEach(projects) { project in
                NavigationLink {
                    ProjectDetailsView(project: project)
                } label: {
                    Text(project.title)
                }
                .tag(project)
            }
            .onDelete(perform: deleteItems)
        }
        #if os(macOS)
        .onDeleteCommand {
            guard selectedProject != nil else { return }
            confirmDelete = true
        }
        #endif
        .alert("Delete Project?", isPresented: $confirmDelete) {
            Button("Delete", role: .destructive) {
                guard let selectedProject else { return }
                modelContext.delete(selectedProject)
                self.selectedProject = nil
            }
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
