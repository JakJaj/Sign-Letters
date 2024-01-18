//
//  CameraController.swift
//  Sign Letters
//
//  Created by Jakub Jajonek on 17/01/2024.
//

import Foundation
import AVFoundation
import SwiftUI
import CoreImage
import CoreML

class CameraController: NSObject, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    private var session = AVCaptureSession()
    var multiArray: MLMultiArray?
    
    lazy var model: model_sign_mnist = {
        do {
            // Use the name of your model file without the extension
            if let modelURL = Bundle.main.url(forResource: "model_sign_mnist", withExtension: "mlmodelc") {
                return try model_sign_mnist(contentsOf: modelURL)
            } else {
                fatalError("Failed to locate the Core ML model file.")
            }
        } catch {
            fatalError("Error loading the Core ML model: \(error)")
        }
    }()
    
    @Published var previewView = UIView()
    
    override init() {
        super.init()
        setupCamera()
    }
    
    func checkForCamera() {
        AVCaptureDevice.requestAccess(for: .video) { (granted) in
            if granted {
                self.startSession()
            } else {
                print("Brak dostępu do kamery.")
            }
        }
    }
    
    private func setupCamera() {
        guard let device = AVCaptureDevice.default(for: .video) else {
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: device)
            if session.canAddInput(input) {
                session.addInput(input)
            }
            
            let output = AVCaptureVideoDataOutput()
            if session.canAddOutput(output) {
                session.addOutput(output)
            }
            
            output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "cameraQueue"))
            
            // Use a `UIViewControllerRepresentable` to wrap the UIKit-based preview layer
            let viewController = UIViewController()
            let previewLayer = AVCaptureVideoPreviewLayer(session: session)
            previewLayer.videoGravity = .resizeAspectFill
            previewLayer.frame = viewController.view.layer.bounds
            viewController.view.layer.addSublayer(previewLayer)
            
            // Convert the `UIViewController` to a SwiftUI view
            previewView = viewController.view
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func startSession() {
        if !session.isRunning {
            session.startRunning()
        }
    }
    
    func stopSession() {
        if session.isRunning {
            session.stopRunning()
        }
    }
    
    
    // Implementuj funkcje delegata AVCaptureVideoDataOutputSampleBufferDelegate, aby otrzymywać dane obrazu
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        // Assume 'sampleBuffer' is your CMSampleBuffer
    }
}
