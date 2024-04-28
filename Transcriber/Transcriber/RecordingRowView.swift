//
//  RecordingRowView.swift
//  AIProxyBootstrap
//
//  Created by Todd Hamilton
//

import SwiftUI


struct RecordingRowView: View {

    let recording: TranscribedAudioRecording
    @State private var startAnimation = false
    
    var body: some View {
        HStack(spacing:0){
            Text(recording.transcript)
                .font(.body)

            Spacer()

            Button{
                recording.play()
            }label:{
                HStack(spacing:6){
                    Image(systemName: "play.circle.fill")
                        .font(.system(size: 15, weight:.semibold, design: .rounded))
                    Text("\(recording.audioRecording.duration)s")
                        .font(.system(size: 11, weight: .regular, design: .monospaced))
                }
            }
            .buttonStyle(TranscriptionButtonStyle())
        }
        .padding(.vertical, 8)
        .opacity(startAnimation ? 1 : 0)
        .offset(y:startAnimation ? 0 : -10)
        .onAppear{
            withAnimation(.smooth.delay(0.2)){
                startAnimation = true
            }
        }   
    }
}

#Preview {
    RecordingRowView(recording: previewRecording())
        .padding()
}

private func previewRecording() -> TranscribedAudioRecording {
    let audioRecording = AudioRecording(url: URL(fileURLWithPath: "/dev/null"),
                                        duration: "1.2s")
    return TranscribedAudioRecording(
        audioRecording: audioRecording,
        transcript: "hello world",
        createdAt: Date()
    )
}

