//
//  CameraViewModel.swift
//  OBD2
//
//  Created by Gibran Shevaldo on 28/09/25.
//

import SwiftUI

@MainActor
class CameraViewModel: ObservableObject {
    @Published var detections: [DetectionResult] = []
    @Published var capturedImageData: Data?
    
    private let mlService = CoreMLService()
    private let storageService = StorageService()
    
    func onFrameUpdate(_ pixelBuffer: CVPixelBuffer?) {
        guard let pixelBuffer = pixelBuffer else { return }
        mlService.performDetection(on: pixelBuffer) { [weak self] results in self?.detections = results }
    }
    
    func captureImage(pixelBuffer: CVPixelBuffer?) {
        guard let pixelBuffer = pixelBuffer else { return }
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let context = CIContext()
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return }
        let uiImage = UIImage(cgImage: cgImage)
        self.capturedImageData = uiImage.jpegData(compressionQuality: 0.8)
    }
    
    func saveCapture() {
        guard let imageData = capturedImageData else { return }
        do {
            _ = try storageService.save(imageData: imageData, metadata: detections)
            self.capturedImageData = nil
            self.detections = []
        } catch {
            print("ViewModel Error: Failed to save capture. \(error)")
        }
    }
}
