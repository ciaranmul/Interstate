//
//  ItemDetailsView.swift
//  Interstate
//
//  Created by Ciarán Mulholland on 22/03/2026.
//

import SwiftData
import SwiftUI

struct ItemDetailsView: View {
    enum FocusedField: Hashable {
        case description
    }

    @Environment(\.dismiss) private var dismiss
    @Bindable var item: Item
    @FocusState var focusedField: FocusedField?

    var body: some View {
        Form {
            TextField("Description", text: $item.entry, axis: .vertical)
                .focused($focusedField, equals: .description)
        }
        .onSubmit {
            dismiss()
        }
        .onAppear {
            focusedField = .description
        }
        #if os(macOS)
        .padding()
        #endif
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

#Preview {
    ItemDetailsView(item: Item())
}
