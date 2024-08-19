//
//  TriviaFormView.swift
//  AIProxyBootstrap
//
//  Created by Todd Hamilton
//

import SwiftUI

struct TriviaFormView:View{

    enum FocusedField {
        case topic
    }

    /// Topic entered by the user in a SwiftUI text field
    @State private var topic = ""
    @Binding var triviaManager: TriviaManager?
    @FocusState private var focusedField: FocusedField?

    var body: some View{

        VStack(spacing:24){
            VStack{
                ZStack{
                    Image(systemName: "doc.questionmark.fill")
                        .foregroundColor(.blue)
                        .rotationEffect(.degrees(-15))
                    Image(systemName: "doc.questionmark.fill")
                        .foregroundColor(.teal)
                        .rotationEffect(.degrees(10))
                    Image(systemName: "doc.questionmark")
                        .foregroundColor(.white)
                    Image(systemName: "doc.questionmark.fill")
                        .overlay {
                            LinearGradient(
                                colors: [.orange, .red, .purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                            .mask(
                                Image(systemName: "doc.questionmark.fill")
                                    .font(.system(size: 72))
                            )
                        }
                }
                .font(.system(size: 72))
                .padding(.vertical, 8)

                Text("Trivia Generator")
                    .font(.system(size: 36, weight:.bold, design: .rounded))
                    .multilineTextAlignment(.center)
                Text("Type a trivia theme below")
                    .font(.system(size: 17, weight:.medium, design: .rounded))
                    .foregroundColor(.secondary)
            }

            VStack{
                TextField("Ex. 80's movies...", text: $topic, axis: .vertical)
                    .focused($focusedField, equals: .topic)
                    .font(.system(size: 17, weight:.medium, design: .rounded))
                    .lineLimit(...3)
                    .textFieldStyle(.plain)
                    .padding()
                    .background(.white)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.clear)
                            .stroke(.separator)
                    )
                    .onAppear {
                        focusedField = .topic
                    }
                Button{
                    withAnimation(){
                        triviaManager = TriviaManager(topic: topic, numCards: 5)
                    }
                }label:{
                    Label("Generate", systemImage: "sparkles")
                        .frame(maxWidth:.infinity)
                        .font(.system(size: 17, weight:.bold, design: .rounded))
                        .fontWeight(.bold)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            }
        }
        .padding()
    }
}
