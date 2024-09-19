//
//  CameraControlsView.swift
//  AIProxyBootstrap
//
//  Created by Lou Zell
//

import Foundation
import SwiftUI

struct CameraControlsView: View {

    let shutterButtonAction: () -> Void

    var body: some View {

        Button(action: shutterButtonAction) {
            ZStack{
                Circle()
                    .fill(.clear)
                    .stroke(.mint, lineWidth: 4)
                    .frame(width:72, height: 72)
                Circle()
                    .fill(.mint.gradient)
                    .frame(width:60, height: 60)
                Image(systemName: "camera")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.black.opacity(0.4))
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    CameraControlsView(shutterButtonAction: {})
}
