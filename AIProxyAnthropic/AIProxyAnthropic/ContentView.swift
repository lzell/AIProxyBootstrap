//
//  ContentView.swift
//  AIProxyAnthropic
//
//  Created by Todd Hamilton on 6/17/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack{
            
            VStack(spacing:24){
                VStack{
                    Image("anthropic")
                        .resizable()
                        .scaledToFit()
                        .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                        .cornerRadius(14)
                        .foregroundColor(.primary)
                    Text("Anthropic")
                        .bold()
                        .font(.largeTitle)
                    Text("AIProxy Sample")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth:.infinity,alignment:.center)
                
                VStack{
                    NavigationLink("Message Request Example",destination: MessageRequestView())
                        .bold()
                        .controlSize(.large)
                        .tint(.brown)
                        .buttonStyle(.bordered)
                    NavigationLink("Vision Example",destination: VisionView())
                        .bold()
                        .controlSize(.large)
                        .tint(.brown)
                        .buttonStyle(.bordered)
                    NavigationLink("Tools Example",destination: ToolsView())
                        .bold()
                        .controlSize(.large)
                        .tint(.brown)
                        .buttonStyle(.bordered)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
