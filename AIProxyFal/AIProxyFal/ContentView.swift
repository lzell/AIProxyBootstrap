//
//  ContentView.swift
//  AIProxyFal
//
//  Created by Todd Hamilton on 6/13/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack{
            
            VStack(spacing:24){
                VStack{
                    Image("fal")
                        .resizable()
                        .scaledToFit()
                        .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                        .cornerRadius(14)
                        .foregroundColor(.primary)
                    Text("Fal")
                        .bold()
                        .font(.largeTitle)
                    Text("AIProxy Sample")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth:.infinity,alignment:.center)
                
                VStack{
                    NavigationLink("Text to Image with FastSDXL",destination: TextToImageView())
                        .bold()
                        .controlSize(.large)
                        .tint(.indigo)
                        .buttonStyle(.bordered)
                    NavigationLink("Image to Video with Runway",destination: ImageToVideoView())
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
