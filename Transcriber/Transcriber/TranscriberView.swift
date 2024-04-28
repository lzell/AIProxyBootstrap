//
//  TranscribeView.swift
//  AIProxyBootstrap
//
//  Created by Todd Hamilton
//

import SwiftData
import SwiftUI
import AVFoundation

@MainActor
struct TranscriberView: View {
    let transcriberManager: TranscriberManager

    var isRecording: Bool {
        transcriberManager.isRecording
    }

    @State private var showDot = false
    @State private var isPulsing = false
    @State private var isProcessing = false
    
    @State var isTimerRunning = false
    @State private var startTime =  Date()
    @State private var timerString = "0:00"
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    // With vibration
    private let startSFX: SystemSoundID = 1113
    private let stopSFX: SystemSoundID = 1114

    private let deviceWidth = UIScreen.main.bounds.width
    private let deviceHeight = UIScreen.main.bounds.height
    
    private var initialX: Double {
        deviceWidth / 2.0
    }
    private var midY: Double {
        -deviceHeight / 2.0 + 80
    }
    
    var body: some View {
        ZStack(alignment:.bottom){
            
            if transcriberManager.recordings.count > 0 {
                List{
                    ForEach(transcriberManager.recordings) { recording in
                        RecordingRowView(recording: recording)
                    }
                    .onDelete { indexSet in
                        if let index = indexSet.first {
                            self.transcriberManager.deleteRecording(at: index)
                        }
                    }
                }
                .listStyle(.plain)
                
            }  else {
                NoRecordingsView()
            }
            
            /// Overlay when recording
            if isRecording {
                ZStack{
                    VStack(spacing:4){
                        Text(isProcessing ? "Processing" : "Recording")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        Text(isProcessing ? "This may take a second" : "\(self.timerString)s")
                            .font(.system(size: 13, weight: .medium, design: .monospaced))
                            .foregroundColor(.secondary)
                            .onReceive(timer) { _ in
                                if self.isTimerRunning {
                                    timerString = String(format: "%.2f", (Date().timeIntervalSince( self.startTime)))
                                }
                            }
                    }
                    .offset(y:-140)
                }
                .frame(maxWidth: .infinity, maxHeight:.infinity)
                .ignoresSafeArea()
                .background(.ultraThinMaterial)
                .transition(.opacity)
            }
            
            GeometryReader { geometry in
                /// Gooey button effect
                Canvas { context, size in
                    let circle0 = context.resolveSymbol(id: 0)!
                    let circle1 = context.resolveSymbol(id: 1)!
                    context.addFilter(.alphaThreshold(min: 0.25, color: .primary))
                    context.addFilter(.blur(radius: 15))
                    context.drawLayer {context in
                        context.draw(circle0, at: CGPoint(x:initialX, y:geometry.size.height - 80))
                        context.draw(circle1, at: CGPoint(x:initialX, y:geometry.size.height - 80))
                    }
                } symbols: {
                    Circle()
                        .frame(width: 80, height: 80)
                        .scaleEffect(isProcessing ? 0.75 : 1, anchor: .center)
                        .tag(0)
                    Circle()
                        .frame(width: 80, height: 80)
                        .tag(1)
                        .scaleEffect(showDot ? 1 : 0.5, anchor: .center)
                        .scaleEffect(isPulsing ? 1.15 : 1, anchor: .center)
                        .offset(y: showDot ? midY : 0)
                }
            }
            
            Button{
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                /// Start  recording
                if !isRecording{
                    Task {
                        await transcriberManager.startRecording()
                    }
                    AudioServicesPlaySystemSound(startSFX)
                    timerString = "0.00"
                    startTime = Date()
                    // start UI updates
                    self.startTimer()
                    withAnimation(.smooth(duration:0.75)){
                        showDot = true
                    }
                    withAnimation(.easeInOut(duration: 0.75).repeatForever(autoreverses: true)){
                        isPulsing = true
                    }
                    isTimerRunning = true
                } else { /// Stop recording
                    Task {
                        await transcriberManager.stopRecording(duration: self.timerString)
                        withAnimation(.bouncy){
                            isProcessing = false
                        }
                    }

                    AudioServicesPlaySystemSound(stopSFX)
                    self.stopTimer()
                    isTimerRunning = false
                    withAnimation(.smooth(duration: 0.75)){
                        showDot = false
                    }
                    withAnimation(.default){
                        isProcessing = true
                        isPulsing = false
                    }
                }
            } label: {
                ZStack{
                    RoundedRectangle(cornerRadius: isRecording ? 8 : 45, style:.continuous)
                        .fill(.red.gradient)
                        .frame(width:isRecording ? 40 : 85, height:isRecording ? 40 : 85)
                        .opacity(isProcessing ? 0 : 1)
                    if isRecording {
                        ProgressView()
                            .opacity(isProcessing ? 1.0 : 0)
                            .tint(.primary)
                            .colorInvert()
                    } else {
                        Image(systemName: "waveform")
                            .font(.title)
                            .foregroundColor(.white)
                            .transition(.scale)
                    }
                    
                }
            }
            .buttonStyle(RecordButton())
            .disabled(isProcessing ? true : false)
        }
    }

    func stopTimer() {
        self.timer.upstream.connect().cancel()
    }
    
    func startTimer() {
        self.timer = Timer.publish(every: 00.01, on: .main, in: .common).autoconnect()
    }
}


#Preview {
    TranscriberView(transcriberManager: TranscriberManager())
}
