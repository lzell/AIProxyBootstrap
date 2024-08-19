//
//  TriviaAnswerPicker.swift
//  AIProxyBootstrap
//
//  Created by Lou Zell
//

import Foundation
import SwiftUI

struct TriviaAnswerPicker: View {
    /// Data model that holds the trivia question, potential answers, and correct answer index
    let questionModel: TriviaQuestionModel

    /// This question position in the stack of trivia cards
    let questionNumber: Int

    /// Number of questions in the stack of trivia cards
    let questionOf: Int

    /// The argument passed to this closure is the guessed answer index for comparison with `questionModel.correctAnswerIndex`
    let didTapAnswer: (Int) -> Void


    var body: some View {
        VStack(alignment:.leading, spacing:36) {

            VStack(alignment:.leading, spacing:16){
                Text("Question \(questionNumber) of \(questionOf)")
                    .font(.system(size: 15, weight:.medium, design: .rounded))
                    .foregroundColor(.secondary)

                Text(questionModel.question)
                    .font(.system(size: 20, weight:.medium, design: .rounded))
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment:.leading)

            VStack(alignment:.leading, spacing:8){
                ForEach(questionModel.labeledAnswers) { labeledAnswer in
                    Text(labeledAnswer.text)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .font(.system(size: 17, weight:.medium, design: .rounded))
            .frame(maxWidth: .infinity, alignment:.leading)

            VStack{
                HStack(spacing:8) {
                    CardButton(systemImageName: "a.circle.fill", tint: .blue) {
                        didTapAnswer(0)
                    }

                    CardButton(systemImageName: "b.circle.fill", tint: .mint) {
                        didTapAnswer(1)
                    }
                }
                HStack {
                    CardButton(systemImageName: "c.circle.fill", tint: .green) {
                        didTapAnswer(2)
                    }

                    CardButton(systemImageName: "d.circle.fill", tint: .indigo) {
                        didTapAnswer(3)
                    }
                }
            }
            .buttonStyle(.bordered)
            .font(.title)
            .frame(maxWidth:.infinity, alignment:.leading)
        }
        .padding(16)
    }
}

private struct CardButton: View {
    let systemImageName: String
    let tint: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: systemImageName)
                .frame(maxWidth: .infinity)
        }
        .tint(tint)
        .controlSize(.large)
    }
}
