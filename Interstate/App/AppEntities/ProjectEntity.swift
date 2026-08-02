//
//  ProjectEntity.swift
//  Interstate
//
//  Created by Ciarán Mulholland on 01/08/2026.
//

import Foundation
import AppIntents
import SwiftData
import CoreSpotlight

struct ProjectEntity: AppEntity, IndexedEntity {
    static var defaultQuery: ProjectEntityQuery {
        ProjectEntityQuery()
    }

    let project: Project

    @ComputedProperty
    var id: String { project.id.uuidString }

    @ComputedProperty(indexingKey: \.displayName)
    var name: String { project.title }

    static let typeDisplayRepresentation = TypeDisplayRepresentation(name: "Project")

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(name)")
    }
}

struct ProjectEntityQuery: EnumerableEntityQuery {
    @Dependency var appModel: AppModel

    func entities(for identifiers: [ProjectEntity.ID]) async throws -> [ProjectEntity] {
        return await appModel.projects
            .filter {
                identifiers.contains($0.id.uuidString)
            }
            .map { ProjectEntity(project: $0) }
    }

    func suggestedEntities() async throws -> [ProjectEntity] {
        try await allEntities()
    }

    func allEntities() async throws -> [ProjectEntity] {
        await appModel.projects.map { ProjectEntity(project: $0) }
    }
}
