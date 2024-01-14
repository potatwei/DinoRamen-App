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
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
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
            
            
            VStack {
                Spacer()
                Button {
                    cameraService.capturePhoto()
                } label: {
                    Image(systemName: "circle")
                        .font(.system(size: 72))
                        .foregroundStyle(.white)
                }
                .padding(.bottom)
            }
        }
    }
}
