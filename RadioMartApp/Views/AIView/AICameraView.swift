//
//  AiCameraView.swift
//  RadioMartApp
//
//  Created by XMaster on 12.10.2023.
//

import SwiftUI
import AVFoundation

struct AICameraView: View {
    //@State var captureSession = AVCaptureSession()
    @State var cameraOn = false
    var body: some View {
        VStack {
            Text("AiCameraView")
                .onAppear{
                    cameraOn = true
                }
                .onDisappear(){
                    //captureSession.stopRunning()
                    cameraOn = false
                }
            CameraPreview(isCameraOn: $cameraOn)

            
        }
        
        
    }
}

#Preview {
    AICameraView()
}
