//
//  GalleryView.swift
//  OBD2
//
//  Created by Gibran Shevaldo on 28/09/25.
//

import SwiftUI

struct GalleryView: View {
    @StateObject private var viewModel = GalleryViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            galleryContent
                .onAppear(perform: viewModel.loadCaptures)
        }
    }
    
    @ViewBuilder
    private var galleryContent: some View {
        if viewModel.captures.isEmpty {
            Text("No secure captures yet.")
//                .font(.headline)
//                .foregroundColor(.secondary)
//                .navigationTitle("Secure Gallery")
//                .toolbar {
//                    ToolbarItemGroup(placement: .navigationBarTrailing) {
//                        doneButton
//                    }
//                }
        } else {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                    ForEach(viewModel.captures) { capture in
                        NavigationLink(destination: DetailView(capture: capture)) {
                            GalleryItemView(capture: capture)
                        }
                    }
                }.padding()
            }
            .navigationTitle("Secure Gallery")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    doneButton
                }
            }
//            Text("Yes secure captures yet.")
        }
    }
    
    private var doneButton: some View {
        Button("Done") {
            dismiss()
        }
    }
}
