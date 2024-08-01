//
//  QuizView.swift
//  AIProxyBootstrap
//
//  Created by Todd Hamilton
//

import SwiftUI

struct TriviaView: View {

    @State private var triviaManager: TriviaManager?

    var body: some View {
        ZStack{

            Rectangle()
                .fill(Color(.secondarySystemBackground))
                .ignoresSafeArea()

            if let triviaManager = self.triviaManager {
                ZStack{

                    if triviaManager.remainingCards.count == 0 {
                        VStack{
                            Text("You answered")
                                .font(.system(size: 15, weight:.bold, design: .rounded))
                                .foregroundColor(.secondary)
                            Text("\(triviaManager.numCorrectOnFirstGuess) out \(triviaManager.numCards) correctly.")
                                .font(.system(size: 24, weight:.semibold, design: .rounded))
                                .multilineTextAlignment(.center)
                            Button("Play again") {
                                self.triviaManager = nil
                            }
                            .fontDesign(.rounded)
                            .fontWeight(.bold)
                            .controlSize(.large)
                            .buttonStyle(.borderedProminent)
                            .padding(.top, 8)
                        }
                    }


                    VStack(spacing:24){
                        Text(triviaManager.topic)
                            .font(.system(size: 24, weight:.bold, design: .rounded))
                            .fontWeight(.bold)
                        ZStack{
                            ForEach(triviaManager.remainingCards) { triviaCard in
                                let cardPosition = triviaCard.position - (triviaManager.remainingCards.first?.position ?? 0)
                                TriviaCardView(triviaCardData: triviaCard, triviaManager: $triviaManager)
                                    .zIndex(1 - Double(cardPosition))
                                    .offset(y: CGFloat(cardPosition) * 25)
                                    .scaleEffect(1.0 - (CGFloat(cardPosition) * 0.05))
                            }
                        }
                        Spacer()
                    }
                    .padding()
                }

            } else {
                TriviaFormView(triviaManager: $triviaManager)
            }
        }
    }
}

#Preview {
    TriviaView()
}



