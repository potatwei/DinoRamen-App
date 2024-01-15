//
//  CameraService.swift
//  LDR
//
//  Created by Shihang Wei on 1/6/24.
//

import Foundation
import AVFoundation
import UIKit

class CameraService {
    
    var session: AVCaptureSession?
    var delegate: AVCapturePhotoCaptureDelegate?
    var usingFrontCamera = false
    var flashLightOn = false
    
    let output = AVCapturePhotoOutput()
    var input: AVCaptureDeviceInput?
    let previewLayer = AVCaptureVideoPreviewLayer()
    
    
    func start(delegate: AVCapturePhotoCaptureDelegate, completion: @escaping (Error?) -> ()) {
        self.delegate = delegate
        checkPermissions(completion: completion)
    }
    
    private func checkPermissions(completion: @escaping (Error?) -> ()) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard granted else { return }
                DispatchQueue.main.async {
                    self?.setupCamera(completion: completion)
                }
            }
        case .restricted:
            break
        case .denied:
            break
        case .authorized:
            setupCamera(completion: completion)
        @unknown default:
            break
        }
    }
    
    private func setupCamera(completion: @escaping (Error?) -> ()) {
        var device = AVCaptureDevice.default(for: .video)

        if !usingFrontCamera {
            if AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back) != nil {
                device = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back)
            } else if AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) != nil {
                device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
            } else {
                fatalError("Missing expected back camera device.")
            }
        } else {
            device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
        }

        let session = AVCaptureSession()
        if let device = device {
            do {
                let input = try AVCaptureDeviceInput(device: device)
                if session.canAddInput(input) {
                    print("Can Input")
                    self.input = input
                    session.addInput(input)
                }
                
                if session.canAddOutput(output) {
                    print("Can Output")
                    session.addOutput(output)
                }
                
                previewLayer.frame = CGRect(x: 0, y: 0, width: 350, height: 550)
                previewLayer.videoGravity = .resizeAspectFill
                previewLayer.session = session
                
                DispatchQueue.global(qos: .background).async {
                    session.startRunning()
                }
                self.session = session
            } catch {
                completion(error)
            }
        }
    }
    
    
    
    func capturePhoto() {
        var settings = AVCapturePhotoSettings()
        settings.flashMode = flashLightOn ? .on : .off
        output.capturePhoto(with: settings, delegate: delegate!)
    }
    
    func switchCamera() {
        var _ = self.delegate!
        
        usingFrontCamera.toggle()
        
        if session != nil{
            guard let _ = self.input else { return }
            
            session?.removeInput(self.input!)
            
            var device = AVCaptureDevice.default(for: .video)

            if !usingFrontCamera {
                if AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back) != nil {
                    device = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back)
                } else if AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) != nil {
                    device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
                } else {
                    fatalError("Missing expected back camera device.")
                }
            } else {
                device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
            }
            
            do {
                let input = try AVCaptureDeviceInput(device: device!)
                
                if session!.canAddInput(input) {
                    print("Can Input")
                    self.input = input
                    session!.addInput(input)
                }
            } catch {
                print(error)
            }
        }

    }
}
