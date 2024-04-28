//
//  ButtonStyles.swift
//  AIProxyBootstrap
//
//  Created by Todd Hamilton
//

import SwiftUI

struct ButtonStyles: View {
    var body: some View {
        
        ZStack{
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack(spacing:48){
                
                Button{
                    /// do something
                }label:{
                    HStack(spacing:6){
                        Image(systemName: "play.circle.fill")
                            .font(.system(size: 15, weight:.semibold, design: .rounded))
                        Text("10s")
                            .font(.system(size: 11, weight: .regular, design: .monospaced))
                            .fontDesign(.monospaced)
                    }
                }
                .buttonStyle(TranscriptionButtonStyle())

                Button(){
                    /// do something
                } label:{
                    Label("Chunky Button", systemImage: "sparkles")
                }
                .buttonStyle(ChunkyButtonStyle(offsetSize: 10.0))

                Button{
                    /// do something
                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 45, style:.continuous)
                            .fill(.red.gradient)
                            .frame(width:85, height:85)
                        Image(systemName: "waveform")
                            .font(.title)
                            .foregroundColor(.white)
                    }
                }
                .buttonStyle(RecordButton())
                
                Button(){
                    /// do something
                }label:{
                    Image(systemName: "arrow.forward")
                        .font(.system(size: 17, weight: .bold))
                }
                .buttonStyle(TranslateButton())
                
            }
            .padding()
        }
        
    }
}

struct ChunkyButtonStyle: ButtonStyle {

    var offsetSize = 10.0

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 24, weight: .bold, design: .rounded))
            .foregroundColor(.black)
            .padding()
            .offset(y: configuration.isPressed ? offsetSize-2 : 0)
            .background(
                GeometryReader{ geo in
                    RoundedRectangle(cornerRadius: 17)
                        .strokeBorder(Color.black, lineWidth: 4)
                        .background(
                            RoundedRectangle(cornerRadius: 17)
                                .fill(.white)
                        )
                        .offset(y:offsetSize)

                        .overlay(
                            RoundedRectangle(cornerRadius: 17)
                                .fill(.white)
                                .strokeBorder(Color.black, lineWidth: 4)
                                .background(RoundedRectangle(cornerRadius: 17).fill(Color.white))
                                .offset(y: configuration.isPressed ? offsetSize : 0)
                        )
                }
            )
    }
}

struct RecordButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth:80, maxHeight: 80)
            .shadow(color:.black.opacity(0.28), radius: 10, y:8)
            .scaleEffect(configuration.isPressed ? 0.9 : 1, anchor: .center)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
            .padding(.bottom, 40)
            
    }
}

struct TranslateButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .frame(width:56, height:56)
            .background(
                Circle()
                    .fill(.teal.gradient)
            )
            .brightness(configuration.isPressed ? -0.1 : 0.0)
            .scaleEffect(configuration.isPressed ? 0.9 : 1, anchor: .center)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct TranscriptionButtonStyle: ButtonStyle {

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.secondary)
            .padding(.leading, 4)
            .padding(.trailing, 8)
            .padding(.vertical, 4)
            .background(
                Capsule().fill(.secondary.opacity(configuration.isPressed ? 0.28 : 0.14))
            )
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
    }
}

#Preview {
    ButtonStyles()
}
