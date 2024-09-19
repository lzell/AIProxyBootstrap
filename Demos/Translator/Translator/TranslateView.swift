//
//  TranslateView.swift
//  AIProxyBootstrap
//
//  Created by Todd Hamilton
//

import SwiftUI

@MainActor
struct TranslateView: View {

    @State private var newText:String = ""
    @State private var translatedText:String = ""
    @State private var processing:Bool = false
    
    private let prompt = "The response is an exact translation from english to spanish. You don't respond with any english."

    var body: some View {
        ZStack{
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack{
                TopTranslateView(
                    newText: $newText,
                    translatedText: $translatedText,
                    translate: { self.translate() }
                )
                BottomTranslateView(
                    processing: $processing,
                    translatedText: $translatedText
                )
            }
            .padding()
        }
    }

    func translate(){
        withAnimation(.smooth){
            processing = true
        }
        Task {
            translatedText = await TranslationDataLoader.run(on: self.newText)
            withAnimation(.smooth){
                processing = false
            }
        }
    }
}

#Preview {
    TranslateView()
}
