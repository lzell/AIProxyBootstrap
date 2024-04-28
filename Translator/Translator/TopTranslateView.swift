//
//  TopTranslateView.swift
//  AIProxyBootstrap
//
//  Created by Todd Hamilton
//

import SwiftUI

struct TopTranslateView: View {

    @Binding var newText:String
    @Binding var translatedText:String
    @State private var showButton: Bool = false
    var translate: () -> Void

    var body: some View {
        VStack(alignment:.leading){
            Text("English")
                .font(.callout)
                .foregroundColor(.secondary)
            TextField("Type something...", text: $newText, axis: .vertical)
                .font(.title2)
                .lineLimit(...2)
                .textFieldStyle(.plain)
                .frame(maxHeight: .infinity, alignment:.topLeading)
                .onChange(of: newText) { _, newValue in
                    withAnimation(.bouncy){
                        if !newValue.isEmpty {
                            showButton = true
                        } else {
                            showButton = false
                        }
                    }
                }

            if showButton {
                HStack(alignment:.bottom){
                    Button{
                        newText = ""
                        translatedText = ""
                        showButton = false
                    } label:{
                        Text("Clear")
                    }

                    Spacer()

                    Button{
                        self.translate()
                    }label:{
                        HStack(spacing:4){
                            Text("Translate")
                            Image(systemName: "arrow.forward")
                        }
                    }
                    .buttonStyle(TranslateButton())
                }
                .transition(.opacity)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color(.tertiarySystemBackground))
                .shadow(color:.black.opacity(0.14), radius: 1)
        )
    }
}

#Preview {
    TopTranslateView(newText: .constant(""), translatedText: .constant(""), translate: {})
}
