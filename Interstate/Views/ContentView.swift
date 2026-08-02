//
//  ContentView.swift
//  Interstate
//
//  Created by Ciarán Mulholland on 21/03/2026.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(AppModel.self) var appModel
    @State private var selectedProject: Project? = nil

    var body: some View {
        @Bindable var appModel = appModel

        NavigationSplitView {
            ProjectsList(projects: $appModel.projects, selectedProject: $selectedProject) {
                appModel.delete($0)
            }
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
            if let selectedProject {
                ProjectDetailsView(project: selectedProject)
            } else {
                ContentUnavailableView("Select a project.", systemImage: "pencil", description: Text("Use '+' to add a new project if you don't see any."))
            }
        }
        .onAppear {
            appModel.fetchData()
        }
    }

    private func addItem() {
        withAnimation {
            let newProject = Project()
            appModel.add(newProject)
        }
    }
}

//extension ContentView {
//    @Observable
//    class ViewModel {
//        let modelContext: ModelContext
//        var projects: [Project]
//        var error: Error?
//
//        init(modelContext: ModelContext) {
//            self.modelContext = modelContext
//            self.projects = []
//        }
//
//        func fetchData() {
//            do {
//                let descriptor = FetchDescriptor<Project>(sortBy: [SortDescriptor(\.title)])
//                projects = try modelContext.fetch(descriptor)
//            } catch {
//                self.error = error
//            }
//        }
//
//        func delete(_ project: Project) {
//            defer {
//                fetchData()
//            }
//
//            modelContext.delete(project)
//        }
//
//        func add(_ project: Project) {
//            defer {
//                fetchData()
//            }
//
//            modelContext.insert(project)
//        }
//    }
//}

//#Preview {
//    ContentView(viewModel: .init(modelContext: .init(.init(for: Item.self, inMemory: true))))
//        .modelContainer(for: Item.self, inMemory: true)
//}
