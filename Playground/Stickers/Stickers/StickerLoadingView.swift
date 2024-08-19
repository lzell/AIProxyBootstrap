//
//  StickerLoadingView.swift
//  AIProxyBootstrap
//
//  Created by Lou Zell
//

import Foundation
import SwiftUI

@MainActor
struct StickerLoadingView: View {

    /// Loading text to display while long requests to OpenAI are fulfilled
    @State private var currentLoadState = "Hold tight"

    var body: some View {
        VStack(spacing:16){
            ProgressView()
                .controlSize(.extraLarge)
                .tint(.white)
            Text(currentLoadState)
                .transition(.move(edge: .bottom))
                .font(.system(size: 20, weight: .semibold, design: .rounded))
                .foregroundColor(.black.opacity(0.28))
        }
        .frame(maxWidth:.infinity, maxHeight:.infinity)
        .onAppear {
            Task {
                try await Task.sleep(for: .seconds(4))
                currentLoadState = "Generating sticker"
                try await Task.sleep(for: .seconds(4))
                currentLoadState = "Finalizing"
            }
        }
    }
}
