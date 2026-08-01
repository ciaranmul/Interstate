//
//  ProjectsList.swift
//  Interstate
//
//  Created by Ciarán Mulholland on 22/03/2026.
//

import SwiftData
import SwiftUI

struct ProjectsList: View {
    @Binding var projects: Array<Project>
    @Binding var selectedProject: Project?
    @State var confirmDelete: Bool = false
    let delete: (Project) -> Void

    var body: some View {
        List(selection: $selectedProject) {
            ForEach(projects) { project in
                NavigationLink(value: project) {
                    Text(project.title)
                }
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
                delete(selectedProject)
                self.selectedProject = nil
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                delete(projects[index])
            }
        }
    }
}
