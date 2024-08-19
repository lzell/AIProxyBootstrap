//
//  ContentView.swift
//  AIProxyTogetherAI
//
//  Created by Todd Hamilton on 8/18/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack{
            
            VStack(spacing:48){
                VStack{
                    Image("togetherai")
                        .resizable()
                        .scaledToFit()
                        .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                        .cornerRadius(14)
                        .foregroundColor(.primary)
                    Text("Together AI")
                        .bold()
                        .font(.largeTitle)
                    Text("AIProxy Sample")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth:.infinity,alignment:.center)
                
                VStack{
                    NavigationLink("Chat Example",destination: ChatView())
                        .bold()
                        .controlSize(.large)
                        .tint(.blue)
                        .buttonStyle(.bordered)
                    NavigationLink("Streaming Chat Example",destination: StreamingChatView())
                        .bold()
                        .controlSize(.large)
                        .tint(.blue)
                        .buttonStyle(.bordered)
                    NavigationLink("JSON Response",destination: JSONResponseView())
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
