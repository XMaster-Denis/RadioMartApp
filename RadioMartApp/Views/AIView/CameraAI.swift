//
//  CameraAI.swift
//  RadioMartApp
//
//  Created by XMaster on 16.10.2023.
//

import SwiftUI
import AVFoundation

struct CameraPreview: UIViewRepresentable {
    
    /*
    let view = UIView(frame: UIScreen.main.bounds)
    
    camera.preview = AVCaptureVideoPreviewLayer(session: camera.session)
    camera.preview.frame = view.frame
    
    // Your Own Properties...
    camera.preview.videoGravity = .resizeAspectFill
    view.layer.addSublayer(camera.preview)
    
    // starting session
    camera.session.startRunning()
    
    return view
    */
    
    
    let session: AVCaptureSession
    
    func makeUIView(context: Context) -> UIView {
        let previewView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width))
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = previewView.layer.bounds
        previewView.layer.addSublayer(previewLayer)
        return previewView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
     //   if let previewLayer = uiView.layer.sublayers?.first as? AVCaptureVideoPreviewLayer {
     //       previewLayer.frame = uiView.layer.bounds
        
    }
}

struct CameraAIPreview: View {
    
    @Binding var isCameraOn: Bool
    
    let captureSession: AVCaptureSession
    
    var isAuthorized: Bool {
        get async {
            let status = AVCaptureDevice.authorizationStatus(for: .video)
            var isAutorized = status == .authorized
            if status == .notDetermined {
                isAutorized = await AVCaptureDevice.requestAccess(for: .video)
            }
            return isAutorized
        }
    }
    
    var body: some View {
        VStack {
            if isCameraOn {
                Text("Camera")
                    CameraPreview(session: captureSession)
                    .onAppear{
                        setupCamera()
                    }
                    .onDisappear{
                        captureSession.stopRunning()
                    }
            }
//            else {
//                Text("Camera is off")
//                
//            }
//            Button(action: {
//                if !isCameraOn {
//                    setupCamera()
//                } else {
//                    captureSession.stopRunning()
//                }
//                isCameraOn.toggle()
//            }) {
//                Text(isCameraOn ? "Turn Off Camera" : "Turn On Camera")
//            }
            
        }
    }
    
    func setupCamera() {
        
        // DispatchQueue.global(qos: .background).async {
        //    guard await isAuthorized else {return}
        
        
        
        captureSession.beginConfiguration()
        if let device = AVCaptureDevice.default(.builtInUltraWideCamera, for: .video, position: .unspecified) {
            do {
                let input = try AVCaptureDeviceInput(device: device)
                if captureSession.canAddInput(input) {
                    captureSession.addInput(input)
                }
            } catch {
                print(error.localizedDescription)
                return
            }
        }
        captureSession.commitConfiguration()
        DispatchQueue.global(qos: .background).async {
            captureSession.startRunning()
        }
    }
    
    //  }
}


//class CameraAI2 {
//    var captureSession: AVCaptureSession = AVCaptureSession()
//    var isAuthorized: Bool {
//        get async {
//            let status = AVCaptureDevice.authorizationStatus(for: .video)
//            var isAutorized = status == .authorized
//            if status == .notDetermined {
//                isAutorized = await AVCaptureDevice.requestAccess(for: .video)
//            }
//            return isAutorized
//        }
//    }
//
//    func setUpCaptureSession() async {
//        guard await isAuthorized else {return}
//        captureSession.beginConfiguration()
//
//        let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .unspecified)
//
//        guard
//            let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice!),
//            captureSession.canAddInput(videoDeviceInput)
//            else {return}
//        captureSession.addInput(videoDeviceInput)
//
//    }
//
//}
