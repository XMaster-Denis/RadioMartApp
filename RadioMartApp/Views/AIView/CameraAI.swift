//
//  CameraAI.swift
//  RadioMartApp
//
//  Created by XMaster on 16.10.2023.
//

import SwiftUI


struct CameraPreview: UIViewControllerRepresentable {
    @Binding var isCameraOn: Bool
    @Binding var selectedCameraIndex: Int
    @Binding var confidenceThreshold: Double
    
    func makeUIViewController(context: Context) -> VisionObjectRecognitionViewController {
        let controller = VisionObjectRecognitionViewController()
        controller.selectedCameraIndex = selectedCameraIndex
        controller.confidenceThreshold = Float(confidenceThreshold)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: VisionObjectRecognitionViewController, context: Context) {
        if uiViewController.selectedCameraIndex != selectedCameraIndex {
            uiViewController.selectedCameraIndex = selectedCameraIndex
            uiViewController.restartCaptureSession()
        }
        
        uiViewController.confidenceThreshold = Float(confidenceThreshold)
        
        if isCameraOn {
            uiViewController.startCaptureSession()
        } else {
            uiViewController.stopCaptureSession()
        }
    }
}




