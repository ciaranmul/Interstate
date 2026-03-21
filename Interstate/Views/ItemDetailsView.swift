//
//  ItemDetailsView.swift
//  Interstate
//
//  Created by Ciarán Mulholland on 22/03/2026.
//

import SwiftData
import SwiftUI

struct ItemDetailsView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var item: Item

    var body: some View {
        Form {
            TextField("Description", text: $item.entry)
        }
        .padding()
        .navigationTitle("Edit entry")
        .toolbar(content: {
#if os(iOS)
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                }
            }
#endif
        })
    }
}
