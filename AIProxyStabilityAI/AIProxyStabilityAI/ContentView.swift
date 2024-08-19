//
//  ContentView.swift
//  AIProxyStabilityAI
//
//  Created by Todd Hamilton on 8/13/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack{
            
            VStack(spacing:48){
                VStack{
                    Image("stability")
                        .resizable()
                        .scaledToFit()
                        .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                        .cornerRadius(14)
                        .foregroundColor(.primary)
                    Text("Stability.ai")
                        .bold()
                        .font(.largeTitle)
                    Text("AIProxy Sample")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth:.infinity,alignment:.center)
                
                VStack{
                    NavigationLink("Generate Image Example",destination: ImageGenView())
                        .bold()
                        .controlSize(.large)
                        .tint(.indigo)
                        .buttonStyle(.bordered)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
