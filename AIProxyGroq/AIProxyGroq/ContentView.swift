//
//  ContentView.swift
//  AIProxyGroq
//
//  Created by Todd Hamilton on 10/1/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack{
            VStack(spacing:24){
                VStack{
                    Image("groq")
                        .resizable()
                        .scaledToFit()
                        .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                        .cornerRadius(14)
                        .foregroundColor(.primary)
                    Text("Groq")
                        .bold()
                        .font(.largeTitle)
                    Text("AIProxy Sample")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth:.infinity,alignment:.center)
                
                VStack{
                    NavigationLink("Chat Completion",destination: ChatView())
                    NavigationLink("Streaming Chat Completion",destination: StreamingChatView())
                }
                .bold()
                .controlSize(.large)
                .tint(.red)
                .buttonStyle(.bordered)
            }
        }
    }
}

#Preview {
    ContentView()
}
