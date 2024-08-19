//
//  NoRecordingsView.swift
//  AIProxyBootstrap
//
//  Created by Todd Hamilton
//

import SwiftUI

struct NoRecordingsView: View {
    var body: some View {
        VStack{
            Image(systemName: "waveform")
                .font(.largeTitle)
                .foregroundColor(.secondary)
                .padding(.bottom, 8)

            Text("No recordings")
                .font(.headline)
            Text("Tap the record button below to start transcribing.")
                .multilineTextAlignment(.center)
                .frame(maxWidth:240)
                .foregroundColor(.secondary)
                .font(.subheadline)
        }
        .frame(maxHeight:.infinity)
        .foregroundColor(.primary)
        .padding(.bottom, 48)
    }
}

#Preview {
    NoRecordingsView()
}
