//
//  GalleryViewModel.swift
//  OBD2
//
//  Created by Gibran Shevaldo on 28/09/25.
//

import Foundation

@MainActor
class GalleryViewModel: ObservableObject {
    @Published var captures: [SecureCapture] = []
    private let storageService = StorageService()
    
    func loadCaptures() {
        let captureIDs = storageService.fetchAllCaptureIDs()
        let loadedCaptures = captureIDs.compactMap { storageService.load(captureID: $0) }
        self.captures = loadedCaptures
    }
}
