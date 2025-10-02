//
//  GalleryItemView.swift
//  OBD2
//
//  Created by Gibran Shevaldo on 28/09/25.
//

import SwiftUI

struct GalleryItemView: View {
    let capture: SecureCapture
    
    var body: some View {
        VStack {
            if let uiImage = UIImage(data: capture.imageData) {
                Image(uiImage: uiImage).resizable().scaledToFill()
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100, maxHeight: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .overlay( VStack { Spacer(); Text(capture.timestamp, style: .time).font(.caption2).padding(2).background(Color.black.opacity(0.5)).foregroundColor(.white).cornerRadius(4).padding(4) } )
            }
        }
    }
}
