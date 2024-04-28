//
//  ClassifierView.swift
//  AIProxyBootstrap
//
//  Created by Todd Hamilton
//

import SwiftUI

@MainActor
struct ClassifierView: View {

    let cameraFrameManager: CameraFrameManager
    let classifierManager: ClassifierManager
    @Environment(\.dismiss) private var dismiss
    @State private var showingSheet = false

    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color(.secondarySystemBackground))
                .ignoresSafeArea()

            VStack {
                CameraView(image: cameraFrameManager.cameraFrameImage)

                Text("Take a photo to identify a plant")
                    .fontWeight(.semibold)
                    .font(.subheadline)
                    .padding(16)
                    .background(Color(.tertiarySystemBackground))
                    .cornerRadius(8)

                CameraControlsView(shutterButtonAction: {
                    if let image = cameraFrameManager.cameraFrameImage {
                        classifierManager.identify(image)
                        showingSheet = true
                    }
                })
                .padding()
                .sheet(isPresented: $showingSheet){
                    SheetView(classifierManager: classifierManager)
                        .presentationDetents([.medium, .large])
                        .presentationBackground(Color(.systemBackground))
                }
            }
        }
    }
}


/// A sheet that slides up over the camera controls to display the results of plant classification
private struct SheetView: View {

    let classifierManager: ClassifierManager
    @Environment(\.dismiss) var dismiss

    var body: some View {
        
        if let plantDescription = classifierManager.plantDescription,
           let plantImage = classifierManager.image {
            ZStack(alignment:.topTrailing){
                Button(){
                    classifierManager.reset()
                    dismiss()
                }label:{
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 32))
                        .foregroundColor(.secondary)
                }
                VStack(spacing:16){
                    Image(uiImage: UIImage(cgImage: plantImage))
                        .resizable()
                        .scaledToFill()
                        .frame(width:80, height:80)
                        .cornerRadius(8)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .fill(.clear)
                                .stroke(.mint, lineWidth:2)
                        )
                        .shadow(radius: 8, x: 0, y: 4)
                    
                    VStack(spacing:8){
                        Text("Description")
                            .font(.title)
                        Text(plantDescription)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    if let wikipediaURL = classifierManager.wikipediaURL {
                        Button(){
                            UIApplication.shared.open(wikipediaURL)
                        } label:{
                            Text("View on Wikipedia")
                                .frame(maxWidth:.infinity)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.large)
                    }
                }
                .padding(.top, 16)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 24)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment:.topLeading)
            .transition(.opacity)
        } else {
            ProgressView()
        }
    }
}


#Preview {
    ClassifierView(cameraFrameManager: CameraFrameManager(),
                   classifierManager: ClassifierManager())
}
