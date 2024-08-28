//
//  ContentView.swift
//  AIProxyReplicate
//
//  Created by Todd Hamilton on 6/13/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack{
            VStack(spacing:24){
                VStack{
                    Image("replicate")
                        .resizable()
                        .scaledToFit()
                        .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                        .cornerRadius(14)
                        .foregroundColor(.primary)
                    Text("Replicate")
                        .bold()
                        .font(.largeTitle)
                    Text("AIProxy Samples")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth:.infinity,alignment:.center)
                
                VStack{
                    NavigationLink("Generate Image Example",destination: ImageGenView())
                        .bold()
                        .controlSize(.large)
                        .tint(.pink)
                        .buttonStyle(.bordered)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

