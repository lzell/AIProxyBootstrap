//
//  StickerImageView.swift
//  AIProxyBootstrap
//
//  Created by Lou Zell
//

import Foundation
import SwiftUI

/// Holds a sticker image.
/// The sticker animates into view with a scale effect, and then floats in the Y-axis.
struct StickerImageView: View {

    /// The sticker as UIImage
    let uiImage: UIImage

    @State private var floating = false
    @State private var showSticker = false
    private let floatingAnimation = Animation.easeInOut(duration: 2.0).repeatForever(autoreverses: true)

    var body: some View {
        Image(uiImage: uiImage)
            .resizable()
            .scaledToFit()
            .cornerRadius(14)
            .shadow(color:.black.opacity(0.28), radius: 8, x:0, y:4)
            .padding()
            .offset(y:floating ? 8.0 : -8.0)
            .animation(floatingAnimation, value: floating)
            .scaleEffect(showSticker ? 1.0 : 0.5)
            .animation(.bouncy, value: showSticker)
            .onAppear{
                withAnimation(.bouncy){
                    floating = true
                    showSticker = true
                }
            }
    }
}

