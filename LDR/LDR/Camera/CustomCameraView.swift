//
//  CustomCameraView.swift
//  LDR
//
//  Created by Shihang Wei on 1/6/24.
//

import SwiftUI

struct CustomCameraView: View {
    
    let cameraService = CameraService()
    @Binding var capturedImage: UIImage?
    @State var flashLightOn = false
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            CameraView(cameraService: cameraService) { result in
                switch result {
                case .success(let photo):
                    if let data = photo.fileDataRepresentation() {
                        //capturedImage = cropImage(UIImage(data: data) ?? UIImage())
                        capturedImage = UIImage(data: data)
                        dismiss()
                    } else {
                        print("Error, no image data found")
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            .frame(maxWidth: 350, maxHeight: 550)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .onDisappear {
                cameraService.session?.stopRunning()
            }
            .padding(.top, 50)
            
            Spacer()
            
            HStack {
                Button {
                    flashLightOn.toggle()
                    cameraService.flashLightOn = flashLightOn
                } label: {
                    Label("FlahLight", systemImage: flashLightOn ? "bolt.fill" : "bolt.slash.fill")
                        .labelStyle(.iconOnly)
                        .font(.system(size: 30))
                        .foregroundStyle(flashLightOn ? .yellow : .white)
                }
                
                Button {
                    cameraService.capturePhoto()
                } label: {
                    Image(systemName: "circle")
                        .font(.system(size: 72))
                        .foregroundStyle(Gradient(colors: [.sugarPink, .sugarYellow]))
                }
                
                Button {
                    cameraService.switchCamera()
                } label: {
                    Label("Switch Camera", systemImage: "camera.rotate.fill")
                        .labelStyle(.iconOnly)
                        .font(.system(size: 30))
                        .foregroundStyle(.white)
                }
            }
            .padding(.bottom, 25)
        }
        .background(.black)
    }
}

#Preview {
    CustomCameraView(capturedImage: .constant(UIImage()))
}
