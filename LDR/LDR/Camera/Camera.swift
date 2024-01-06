//
//  Camera.swift
//  LDR
//
//  Created by Shihang Wei on 1/6/24.
//

import SwiftUI

struct Camera: View {
    
    @State private var capturedImage: UIImage? = nil
    @State private var isCustomCameraViewPresented = false
    
    var body: some View {
        ZStack {
            if capturedImage != nil {
                Image(uiImage: capturedImage!)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            } else {
                Color(UIColor.systemBackground)
            }
            
            VStack {
                Spacer()
                Button {
                    isCustomCameraViewPresented.toggle()
                } label: {
                    Image(systemName: "camera.fill")
                        .font(.largeTitle)
                        .padding()
                        .background(.black)
                        .foregroundStyle(.white)
                        .clipShape(Circle())
                }
                .padding(.bottom)
                .sheet(isPresented: $isCustomCameraViewPresented, content: {
                    CustomCameraView(capturedImage: $capturedImage)
                })
            }
        }
    }
}

#Preview {
    Camera()
}
