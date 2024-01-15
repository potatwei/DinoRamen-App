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
    @State var currentZoomFactor: CGFloat = 1.0
    
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
            .padding(.top, 50)
            .onDisappear {
                cameraService.session?.stopRunning()
            }
            .gesture(
                MagnifyGesture().onChanged({ value in
                    if value.velocity < 0 {
                        currentZoomFactor = currentZoomFactor - value.magnification / 17
                    } else {
                        currentZoomFactor = currentZoomFactor + value.magnification / 30

                    }
                    currentZoomFactor = min(max(currentZoomFactor, 1), 5)
                    cameraService.setZoom(factor: currentZoomFactor)
                })
            )
            
            
            Spacer()
            
            HStack {
                Spacer()
                
                Button {
                    flashLightOn.toggle()
                    cameraService.flashLightOn = flashLightOn
                } label: {
                    Label("FlahLight", systemImage: flashLightOn ? "bolt.fill" : "bolt.slash.fill")
                        .labelStyle(.iconOnly)
                        .font(.system(size: 30))
                        .foregroundStyle(flashLightOn ? .yellow : .white)
                        .animation(.snappy, value: flashLightOn)
                        .frame(width: 60, height: 50)
                        //.border(.white)
                }
                .padding(.trailing, 30)
                //.border(.white)
                
                Button {
                    cameraService.capturePhoto()
                } label: {
                    Image(systemName: "circle")
                        .font(.system(size: 72))
                        .foregroundStyle(Gradient(colors: [.sugarPink, .sugarYellow]))
                }
                
                Button {
                    cameraService.switchCamera()
                    currentZoomFactor = 1
                } label: {
                    Label("Switch Camera", systemImage: "camera.rotate.fill")
                        .labelStyle(.iconOnly)
                        .font(.system(size: 30))
                        .foregroundStyle(.white)
                        .frame(width: 60, height: 50)
                        //.border(.white)
                }
                .padding(.leading, 30)
                //.border(.white)
                
                Spacer()
            }
            .padding(.bottom, 25)
        }
        .background(.black)
    }
}

#Preview {
    CustomCameraView(capturedImage: .constant(UIImage()))
}
