//
//  CameraView.swift
//  AIProxyBootstrap
//
//  Created by Todd Hamilton
//

import SwiftUI

struct CameraView: View {

    /// The camera frame image to display
    var image: CGImage?

    private let label = Text("frame")
    
    var body: some View {
        GeometryReader { geo in
           VStack {
               if let image = image {
                   Image(image, scale: 0.5, orientation: .up, label: label)
                       .resizable()
                       .scaledToFill()
                       .frame(maxWidth:geo.size.width, maxHeight: geo.size.width)
                       .clipShape(RoundedRectangle(cornerRadius: 14))
                       .padding()

               } else {
                   Color.black
                       .frame(maxWidth:geo.size.width, maxHeight: geo.size.width)
                       .clipShape(RoundedRectangle(cornerRadius: 14))
                       .padding()
               }
           }
        }
    }
}

#Preview {
    CameraView()
}
