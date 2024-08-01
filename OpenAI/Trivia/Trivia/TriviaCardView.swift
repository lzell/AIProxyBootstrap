//
//  QuizView.swift
//  AIProxyBootstrap
//
//  Created by Todd Hamilton
//

import Foundation
import SwiftUI

@MainActor
struct TriviaCardView: View {

    let triviaCardData: TriviaCardData
    @Binding var triviaManager: TriviaManager?
    @State var attempts: Int = 0
    @State var isCorrect = false

    private var questionNumber: Int {
        triviaCardData.position + 1
    }

    private var totalQuestions: Int {
        triviaManager?.triviaCards.count ?? 0
    }

    var body: some View{
        ZStack {
            if let model = triviaCardData.triviaQuestionModel {
                ZStack {
                    TriviaAnswerPicker(
                        questionModel: model,
                        questionNumber: questionNumber,
                        questionOf: totalQuestions
                    ) { guessIndex in
                        checkAnswer(forQuestion: model, withGuessedIndex: guessIndex)
                    }

                    if self.isCorrect {
                        Rectangle()
                            .fill(.black.opacity(0.4))
                            .frame(width: .infinity, height: .infinity)
                            .transition(.opacity)
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 64))
                            .foregroundColor(.green)
                            .background(.white)
                            .clipShape(Circle())
                            .transition(.scale(0.5).combined(with: .opacity))
                    }
                }
            } else {
                VStack(spacing:16) {
                    ProgressView()
                    Text("Generating questions")
                        .font(.system(size: 15, weight:.regular, design:.rounded))
                        .foregroundColor(.secondary)
                }
                .frame(maxHeight:.infinity)
            }
        }
        .frame(maxWidth: .infinity, maxHeight:480, alignment:.top)
        .background(Color(.systemBackground))
        .cornerRadius(14)
        .shadow(color: .black.opacity(0.14), radius: 1, x: 0, y: 1)
        .modifier(Shake(animatableData: CGFloat(attempts)))
    }


    private func checkAnswer(forQuestion question: TriviaQuestionModel, withGuessedIndex guessedIndex: Int) {
        triviaManager?.trackGuess(ofQuestion: question)
        if (question.correctAnswerIndex == guessedIndex) {
            withAnimation(.bouncy){
                isCorrect = true
            }
            Task {
                try await Task.sleep(for: .seconds(1))
                withAnimation(.bouncy) {
                    triviaManager?.progress()
                }
            }
        } else {
            withAnimation(.default) {
                attempts += 1
            }
        }
    }
}


private struct Shake: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit = 3
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX:
            amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
            y: 0))
    }
}
