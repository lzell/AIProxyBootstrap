//
//  MovieDetailsView.swift
//  MovieMoods
//
//  Created by Todd Hamilton on 10/29/24.
//

import SwiftUI

struct MovieDetailsView: View {
    
    @Binding var movieID: String
    @Binding var movieBackdrop: String
    @Binding var movieTitle: String
    @Binding var movieReleaseDate: String
    @Binding var movieOverview: String
    @Binding var genreLabel: String
    
    @State var showPoster:Bool = false
    @State var showTitle:Bool = false
    @State var showRelease:Bool = false
    @State var showOverview:Bool = false
    @State var showCTA:Bool = false
    
    var body: some View {
        VStack(spacing:24){
            
            
            AsyncImage(
                url: URL(string: "https://image.tmdb.org/t/p/w1920_and_h800_multi_faces/\(movieBackdrop)"),
                content: { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth:.infinity)
                        .clipped()
                        .cornerRadius(8)
                        
                },
                placeholder: {
                    Color.clear
                }
            )
            .opacity(showPoster ? 1 : 0)

            VStack(spacing:24){
                
                Text(movieTitle)
                    .font(.title2)
                    .fontWeight(.bold)
                    .frame(maxWidth:.infinity, alignment: .leading)
                    .opacity(showTitle ? 1 : 0)
                
                VStack(spacing:8){
                    Text("Release date")
                        .frame(maxWidth:.infinity, alignment: .leading)
                        .foregroundColor(.secondary)
                        .textCase(.uppercase)
                    Text("\(movieReleaseDate)")
                        .frame(maxWidth:.infinity, alignment: .leading)
                }
                .font(.caption)
                .opacity(showRelease ? 1 : 0)
                
                VStack(spacing:8){
                    Text("Overview")
                        .frame(maxWidth:.infinity, alignment: .leading)
                        .foregroundColor(.secondary)
                        .textCase(.uppercase)
                    Text(movieOverview)
                        .frame(maxWidth:.infinity, alignment: .leading)
                }
                .font(.caption)
                .opacity(showOverview ? 1 : 0)
                
            }
            .fontDesign(.monospaced)
            
            Link(destination: URL(string: "https://www.themoviedb.org/movie/\(movieID)")!){
                Text("View on TMDB")
                    .foregroundColor(.black)
                    .padding(6)
                    .frame(maxWidth:.infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(.white)
            .fontDesign(.monospaced)
            .fontWeight(.bold)
            .opacity(showCTA ? 1 : 0)
            
            Spacer()
        }
        .padding(16)
        .padding(.top, 12)
        .preferredColorScheme(.dark)
        .onAppear(){
            withAnimation(.easeInOut.delay(0.2)){
                showPoster.toggle()
            }
            withAnimation(.easeInOut.delay(0.25)){
                showTitle.toggle()
            }
            withAnimation(.easeInOut.delay(0.3)){
                showRelease.toggle()
            }
            withAnimation(.easeInOut.delay(0.35)){
                showOverview.toggle()
            }
            withAnimation(.easeInOut.delay(0.4)){
                showCTA.toggle()
            }
        }
    }
}

#Preview {
    MovieDetailsView(
        movieID: .constant("23232"),
        movieBackdrop: .constant("p5ozvmdgsmbWe0H8Xk7Rc8SCwAB.jpg"),
        movieTitle: .constant("Inside Out 2"),
        movieReleaseDate: .constant("06/14/2024 (US)"),
        movieOverview: .constant("Teenager Riley's mind headquarters is undergoing a sudden demolition to make room for something entirely unexpected: new Emotions! Joy, Sadness, Anger, Fear and Disgust, who’ve long been running a successful operation by all accounts, aren’t sure how to feel when Anxiety shows up. And it looks like she’s not alone."),
        genreLabel: .constant("Comedy")
    )
}
