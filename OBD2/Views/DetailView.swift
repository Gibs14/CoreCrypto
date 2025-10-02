//
//  DetailView.swift
//  OBD2
//
//  Created by Gibran Shevaldo on 28/09/25.
//

import SwiftUI

struct DetailView: View {
    let capture: SecureCapture
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let uiImage = UIImage(data: capture.imageData) { Image(uiImage: uiImage).resizable().scaledToFit().clipShape(RoundedRectangle(cornerRadius: 12)) }
                VStack(alignment: .leading) {
                    Text("Capture Details").font(.title2).fontWeight(.bold)
                    Text("Captured on \(capture.timestamp.formatted(date: .long, time: .standard))").font(.subheadline).foregroundColor(.secondary)
                }.padding(.horizontal)
                Divider()
                VStack(alignment: .leading) {
                    Text("Detection Results").font(.title2).fontWeight(.bold)
                    if capture.detections.isEmpty { Text("No objects detected.").foregroundColor(.secondary) }
                    else {
                        ForEach(capture.detections) { detection in
                            HStack {
                                Text(detection.label).fontWeight(.semibold)
                                Spacer()
                                Text("Confidence: \(detection.confidence * 100, specifier: "%.1f")%").foregroundColor(.secondary)
                            }.padding(.vertical, 4)
                        }
                    }
                }.padding(.horizontal)
            }
        }.navigationTitle("Capture Details").navigationBarTitleDisplayMode(.inline)
    }
}
