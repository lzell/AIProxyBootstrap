//
//  ContentView.swift
//  AIProxyDeepL
//
//  Created by Todd Hamilton on 8/14/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack{
            
            VStack(spacing:48){
                VStack{
                    Image("deepl")
                        .resizable()
                        .scaledToFit()
                        .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                        .cornerRadius(14)
                        .foregroundColor(.primary)
                    Text("DeepL")
                        .bold()
                        .font(.largeTitle)
                    Text("AIProxy Sample")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth:.infinity,alignment:.center)
                
                VStack{
                    NavigationLink("Translation Example",destination: TranslationView())
                        .bold()
                        .controlSize(.large)
                        .tint(.blue)
                        .buttonStyle(.bordered)
                    
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
