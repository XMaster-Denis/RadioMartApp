//
//  AiCameraView.swift
//  RadioMartApp
//
//  Created by XMaster on 12.10.2023.
//

import SwiftUI
import AVFoundation

struct AICameraView: View {
    let captureSession = AVCaptureSession()
    @State var cameraOn = false
    var body: some View {
        VStack {
            Text("AiCameraView")
            CameraAIPreview(isCameraOn: $cameraOn, captureSession: captureSession)
            
        }
        .onAppear{
            cameraOn = true
        }
    }
}

#Preview {
    AICameraView()
}
