//
//  CoreMlServices.swift
//  OBD2
//
//  Created by Gibran Shevaldo on 25/09/25.
//

import Foundation
import CoreML
import Vision

// --- CORE ML SERVICE ---
// IMPORTANT: To make this work:
// 1. Download a Core ML model (e.g., YOLOv3-Tiny).
// 2. Drag the .mlmodel file into your Xcode project.
// 3. Xcode automatically generates a Swift class for it (e.g., `YOLOv3Tiny`).
// 4. Update the model name in `init()` if you use a different model.
class CoreMLService {
    private var visionModel: VNCoreMLModel?

    init() {
        // This is a placeholder for the model loading.
        // In a real app, you would have the YOLOv3Tiny.mlmodel file in your project.
        // For this environment, this will gracefully fail, and the app will show no detections.
        guard let modelURL = Bundle.main.url(forResource: "YOLOv3Tiny", withExtension: "mlmodelc") else {
            print("ML Error: YOLOv3Tiny.mlmodelc not found in bundle.")
            return
        }
        do {
            let coreMLModel = try MLModel(contentsOf: modelURL)
            self.visionModel = try VNCoreMLModel(for: coreMLModel)
            print("ML Service: Successfully loaded Core ML model.")
        } catch {
            print("ML Error: Failed to load Core ML model: \(error)")
        }
    }

    func performDetection(on pixelBuffer: CVPixelBuffer, completion: @escaping ([DetectionResult]) -> Void) {
        guard let visionModel = visionModel else {
            completion([])
            return
        }

        let request = VNCoreMLRequest(model: visionModel) { request, error in
            if let error = error {
                print("ML Error: Vision request failed: \(error)")
                completion([])
                return
            }

            guard let results = request.results as? [VNRecognizedObjectObservation] else {
                completion([])
                return
            }

            let detectionResults = results.map { observation -> DetectionResult in
                let bestLabel = observation.labels.first?.identifier ?? "Unknown"
                let confidence = observation.labels.first?.confidence ?? 0
                let flippedBox = CGRect(
                    x: observation.boundingBox.origin.x,
                    y: 1 - observation.boundingBox.origin.y - observation.boundingBox.height,
                    width: observation.boundingBox.width,
                    height: observation.boundingBox.height
                )
                return DetectionResult(label: bestLabel, confidence: confidence, boundingBox: flippedBox)
            }
            
            DispatchQueue.main.async {
                completion(detectionResults)
            }
        }
        
        request.imageCropAndScaleOption = .scaleFill

        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
        try? handler.perform([request])
    }
}
