//
//  MenuBarView.swift
//  Interstate
//
//  Created by Ciarán Mulholland on 02/04/2026.
//

import SwiftUI

@available(macOS 26, *)
struct MenuBarView: View {
    var body: some View {
        NavigationStack {
            MenuBarProjectsList()
        }
    }
}
