//
//  BottomTranslateView.swift
//  AIProxyBootstrap
//
//  Created by Todd Hamilton
//

import SwiftUI

struct BottomTranslateView: View {

    @Binding var processing:Bool
    @Binding var translatedText:String

    var body: some View {
        VStack{

            VStack(alignment:.leading, spacing:8){
                Text("Spanish")
                    .font(.callout)
                    .foregroundColor(.secondary)
                if processing {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight:.infinity)
                } else{
                    Text(translatedText)
                        .font(.title2)
                }
            }
            .frame(maxWidth: .infinity, maxHeight:.infinity, alignment:.topLeading)


            HStack(spacing:0){
                Button(){
                    /// copy result
                } label:{
                    Image(systemName: "square.on.square")
                        .font(.title2)
                }
                .frame(width:44, height:44)
            }
            .frame(maxWidth: .infinity, alignment:.leading)
        }
        .frame(maxWidth: .infinity, maxHeight:.infinity)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color(.tertiarySystemBackground))
                .shadow(color:.black.opacity(0.14), radius: 1)
        )
    }
}


#Preview {
    BottomTranslateView(processing: .constant(false), translatedText: .constant(""))
}
