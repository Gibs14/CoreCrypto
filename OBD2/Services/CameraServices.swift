//
//  CameraServices.swift
//  OBD2
//
//  Created by Gibran Shevaldo on 28/09/25.
//

import Foundation
import AVFoundation

class CameraService: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate, ObservableObject {
    @Published var currentFrame: CVPixelBuffer?
    
    let captureSession = AVCaptureSession()
    private let videoOutput = AVCaptureVideoDataOutput()
    private let sessionQueue = DispatchQueue(label: "cameraSessionQueue")
    
    override init() {
        super.init()
        setupSession()
    }
    
    private func setupSession() {
        sessionQueue.async { [weak self] in
            guard let self = self else { return }
            self.captureSession.beginConfiguration()
            self.captureSession.sessionPreset = .photo
            
            guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else { return }
            
            do {
                let deviceInput = try AVCaptureDeviceInput(device: videoDevice)
                if self.captureSession.canAddInput(deviceInput) { self.captureSession.addInput(deviceInput) }
            } catch { return }
            
            self.videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoOutputQueue"))
            self.videoOutput.alwaysDiscardsLateVideoFrames = true
            self.videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
            
            if self.captureSession.canAddOutput(self.videoOutput) { self.captureSession.addOutput(self.videoOutput) }
            
            self.captureSession.commitConfiguration()
        }
    }
    
    func start() { sessionQueue.async { if !self.captureSession.isRunning { self.captureSession.startRunning() } } }
    func stop() { sessionQueue.async { if self.captureSession.isRunning { self.captureSession.stopRunning() } } }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) {
            DispatchQueue.main.async { self.currentFrame = pixelBuffer }
        }
    }
}
