//
//  CameraView.swift
//  OBD2
//
//  Created by Gibran Shevaldo on 28/09/25.
//

import SwiftUI

struct CameraView: View {
    @StateObject private var viewModel = CameraViewModel()
    @StateObject private var cameraService = CameraService()
    @State private var showGallery = false
    
    var body: some View {
        NavigationView {
            ZStack {
                CameraPreview(cameraService: cameraService)
                    .ignoresSafeArea()
                    .onAppear(perform: cameraService.start)
                    .onDisappear(perform: cameraService.stop)
                    .onReceive(cameraService.$currentFrame) { frame in
                        if viewModel.capturedImageData == nil { viewModel.onFrameUpdate(frame) }
                    }
                DetectionOverlayView(detections: viewModel.detections)
                VStack {
                    Spacer()
                    if let imageData = viewModel.capturedImageData {
                        CaptureConfirmationView(imageData: imageData,
                                                onConfirm: viewModel.saveCapture,
                                                onRetake: { viewModel.capturedImageData = nil })
                    } else {
                        captureButton
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Secure Camera")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showGallery = true }) {
                        Image(systemName: "photo.on.rectangle.angled").font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showGallery) { GalleryView() }
        }
    }
    
    private var captureButton: some View {
        Button(action: { viewModel.captureImage(pixelBuffer: cameraService.currentFrame) }) {
            Circle().fill(.white).frame(width: 70, height: 70)
                .overlay(Circle().stroke(.white, lineWidth: 4).padding(4))
        }.padding(.bottom, 30)
    }
}
