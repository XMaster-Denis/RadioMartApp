//
//  AiCameraView.swift
//  RadioMartApp
//
//  Created by XMaster on 12.10.2023.
//

import SwiftUI
import AVFoundation

struct AICameraView: View {
    @State var cameraOn = false
    @State var cameraIndex = 0
    @State var cameraNames: [LocalizedStringKey] = []
    @State var confidenceThreshold: Double = 0.9
    
    var body: some View {
        VStack (spacing: 20) {
            Text("AiCameraView")
                .onAppear{
                    cameraOn = true
                    
                    let devices = AVCaptureDevice.DiscoverySession(
                        deviceTypes: [.builtInWideAngleCamera, .builtInUltraWideCamera, .builtInTelephotoCamera],
                        mediaType: .video,
                        position: .back
                    ).devices
                    cameraNames = devices.map { device in
                        switch device.deviceType {
                        case .builtInWideAngleCamera: return LocalizedStringKey("camera.wide:string")
                        case .builtInUltraWideCamera: return LocalizedStringKey("camera.ultrawide:string")
                        case .builtInTelephotoCamera: return LocalizedStringKey("camera.telephoto:string")
                        default: return LocalizedStringKey("camera.unknown:string")
                        }
                    }
                }
                .onDisappear(){
                    cameraOn = false
                }
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                VStack {
                    Picker("", selection: $cameraIndex) {
                        ForEach(0..<cameraNames.count, id: \.self) { index in
                            Text(cameraNames[index])
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    Section("сonfidence.threshold:string") {
                        VStack(alignment: .leading) {
                            Text("confidence: \(String(format: "%.2f", confidenceThreshold)):string")
                                .font(.caption)
                            Slider(value: $confidenceThreshold, in: 0.8...1.0, step: 0.01)
                        }
                    }
                    CameraPreview(isCameraOn: $cameraOn, selectedCameraIndex: $cameraIndex, confidenceThreshold: $confidenceThreshold)
                }
            } else {
                Text("cameras.are.not.available:string")
                    .foregroundColor(.red)
                    .padding()
            }
            
        }
        
        
    }
}

#Preview {
    AICameraView()
}
