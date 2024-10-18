//
//  ContentView.swift
//  AIProxyGemini
//
//  Created by Todd Hamilton on 10/18/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack{
            VStack(spacing:24){
                VStack{
                    Image("icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                        .cornerRadius(14)
                        .foregroundColor(.primary)
                    Text("Gemini")
                        .bold()
                        .font(.largeTitle)
                    Text("AIProxy Sample")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth:.infinity,alignment:.center)
                
                VStack{
                    NavigationLink("Text Generation",destination: TextGenerationView())
                }
                .bold()
                .controlSize(.large)
                .tint(.teal)
                .buttonStyle(.bordered)
            }
        }
    }
}

#Preview {
    ContentView()
}
