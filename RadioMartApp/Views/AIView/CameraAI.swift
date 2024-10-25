//
//  CameraAI.swift
//  RadioMartApp
//
//  Created by XMaster on 16.10.2023.
//

import SwiftUI


struct CameraPreview: UIViewControllerRepresentable {
    @Binding var isCameraOn: Bool
    
    func makeUIViewController(context: Context) -> VisionObjectRecognitionViewController {
        let controller = VisionObjectRecognitionViewController()
        return controller
    }
    
    func updateUIViewController(_ uiViewController: VisionObjectRecognitionViewController, context: Context) {
        if isCameraOn {
            uiViewController.startCaptureSession()
        } else {
            uiViewController.stopCaptureSession()
        }
    }
}




