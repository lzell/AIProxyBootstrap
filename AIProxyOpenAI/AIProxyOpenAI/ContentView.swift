//
//  ContentView.swift
//  AIProxyOpenAI
//
//  Created by Todd Hamilton on 6/14/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack{
            
            VStack(spacing:48){
                VStack{
                    Image("openai")
                        .resizable()
                        .scaledToFit()
                        .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                        .cornerRadius(14)
                        .foregroundColor(.primary)
                    Text("OpenAI")
                        .bold()
                        .font(.largeTitle)
                    Text("AIProxy Sample")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth:.infinity,alignment:.center)
                
                VStack{
                    NavigationLink("Chat Example",destination: ChatView())
                    NavigationLink("Streaming Chat Example",destination: ChatView())
                    NavigationLink("Multi-Modal Chat Example",destination: MultiModalChatView())
                    NavigationLink("DALLE Example",destination: DalleView())
                    NavigationLink("Text-to-Speech Example",destination: TextToSpeechView())
                }
                .bold()
                .controlSize(.large)
                .buttonStyle(.bordered)
                .tint(.purple)
            }
        }
    }
}

#Preview {
    ContentView()
}
