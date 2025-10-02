//
//  DetectionOverlayView.swift
//  OBD2
//
//  Created by Gibran Shevaldo on 28/09/25.
//

import SwiftUI

struct DetectionOverlayView: View {
    let detections: [DetectionResult]
    
    var body: some View {
        GeometryReader { geometry in
            ForEach(detections) { detection in
                let rect = CGRect(x: detection.boundingBox.origin.x * geometry.size.width,
                                  y: detection.boundingBox.origin.y * geometry.size.height,
                                  width: detection.boundingBox.width * geometry.size.width,
                                  height: detection.boundingBox.height * geometry.size.height)
                ZStack(alignment: .topLeading) {
                    Rectangle().stroke(Color.yellow, lineWidth: 3)
                    Text("\(detection.label) (\(detection.confidence, specifier: "%.2f"))")
                        .font(.caption).padding(4).background(Color.yellow).foregroundStyle(.black).offset(y: -24)
                }.frame(width: rect.width, height: rect.height).position(x: rect.midX, y: rect.midY)
            }
        }
    }
}
