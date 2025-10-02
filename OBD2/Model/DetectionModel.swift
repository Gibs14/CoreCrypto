//
//  DetectionModel.swift
//  OBD1
//
//  Created by Gibran Shevaldo on 23/09/25.
//

import SwiftUI
 
// A simple struct to hold the results of an object detection.
struct DetectionResult: Codable, Identifiable {
    let id = UUID()
    let label: String
    let confidence: Float
    let boundingBox: CGRect // Stored as a CGRect for easy use in SwiftUI
    
    // Custom coding keys to handle CGRect conversion to/from Codable
    enum CodingKeys: String, CodingKey {
        case label, confidence, boundingBox
    }
    
    init(label: String, confidence: Float, boundingBox: CGRect) {
        self.label = label
        self.confidence = confidence
        self.boundingBox = boundingBox
    }
    
    // Decodable Initializer
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        label = try container.decode(String.self, forKey: .label)
        confidence = try container.decode(Float.self, forKey: .confidence)
        let boxArray = try container.decode([CGFloat].self, forKey: .boundingBox)
        boundingBox = CGRect(x: boxArray[0], y: boxArray[1], width: boxArray[2], height: boxArray[3])
    }
    
    // Encodable Function
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(label, forKey: .label)
        try container.encode(confidence, forKey: .confidence)
        let boxArray = [boundingBox.origin.x, boundingBox.origin.y, boundingBox.size.width, boundingBox.size.height]
        try container.encode(boxArray, forKey: .boundingBox)
    }
}

// Represents a single, securely saved capture, decrypted and ready for display.
struct SecureCapture: Identifiable {
    let id: String // The UUID filename
    let timestamp: Date
    let imageData: Data // This is the DECRYPTED image data
    let detections: [DetectionResult]
}
