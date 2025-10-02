//
//  StorageServices.swift
//  OBD1
//
//  Created by Gibran Shevaldo on 23/09/25.
//

import SwiftUI
import CoreData

class StorageService {
    private let fileManager = FileManager.default
    private let coreDataContext = CoreDataStack.shared.context
    
    private lazy var storageURL: URL = {
        let url = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        if !fileManager.fileExists(atPath: url.path) {
            try? fileManager.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        }
        return url
    }()

    func save(imageData: Data, metadata: [DetectionResult]) throws -> String {
        let id = UUID()
        let fileName = "\(id.uuidString).jpg.encrypted"
        let imageURL = storageURL.appendingPathComponent(fileName)
        
        // 1. Encrypt and save image file
        let cryptoService = CryptoService()
        let encryptedImageData = try cryptoService.encrypt(data: imageData)
        let options: Data.WritingOptions = [.atomic, .completeFileProtection]
        try encryptedImageData.write(to: imageURL, options: options)
        
        // 2. Save metadata to Core Data
        let captureMetadata = CaptureMetadata(context: coreDataContext)
        captureMetadata.id = id
        captureMetadata.timestamp = Date()
        captureMetadata.imageFileName = fileName
        
        for detectionResult in metadata {
            let detectionEntity = Detection(context: coreDataContext)
            detectionEntity.label = detectionResult.label
            detectionEntity.confidence = detectionResult.confidence
            detectionEntity.box_x = Float(detectionResult.boundingBox.origin.x)
            detectionEntity.box_y = Float(detectionResult.boundingBox.origin.y)
            detectionEntity.box_w = Float(detectionResult.boundingBox.width)
            detectionEntity.box_h = Float(detectionResult.boundingBox.height)
            captureMetadata.addToDetections(detectionEntity)
        }
        
        CoreDataStack.shared.saveContext()
        
        return id.uuidString
    }
    
    func load(captureID: String) -> SecureCapture? {
        guard let uuid = UUID(uuidString: captureID) else { return nil }
        
        let request: NSFetchRequest<CaptureMetadata> = CaptureMetadata.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", uuid as CVarArg)
        
        do {
            guard let metadataEntity = try coreDataContext.fetch(request).first,
                  let fileName = metadataEntity.imageFileName else {
                return nil
            }
            
            // 1. Load and decrypt image data
            let imageURL = storageURL.appendingPathComponent(fileName)
            let cryptoService = CryptoService()
            let encryptedImageData = try Data(contentsOf: imageURL)
            let decryptedImageData = try cryptoService.decrypt(data: encryptedImageData)
            
            // 2. Convert Core Data Detections to DetectionResult structs
            let detectionResults = (metadataEntity.detections as? Set<Detection> ?? []).map {
                DetectionResult(
                    label: $0.label ?? "Unknown",
                    confidence: $0.confidence,
                    boundingBox: CGRect(x: CGFloat($0.box_x), y: CGFloat($0.box_y), width: CGFloat($0.box_w), height: CGFloat($0.box_h))
                )
            }
            
            return SecureCapture(
                id: captureID,
                timestamp: metadataEntity.timestamp ?? Date(),
                imageData: decryptedImageData,
                detections: detectionResults
            )
        } catch {
            print("Storage Error: Failed to load capture \(captureID). Error: \(error)")
            return nil
        }
    }
    
    func fetchAllCaptureIDs() -> [String] {
        let request: NSFetchRequest<CaptureMetadata> = CaptureMetadata.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \CaptureMetadata.timestamp, ascending: false)]
        
        do {
            let results = try coreDataContext.fetch(request)
            return results.compactMap { $0.id?.uuidString }
        } catch {
            print("Storage Error: Could not fetch capture IDs. Error: \(error)")
            return []
        }
    }
}
