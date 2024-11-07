//
//  ContentView.swift
//  FilmFinder
//
//  Created by Todd Hamilton on 10/28/24.
//

import Foundation
import SwiftUI
import AIProxy
import UIKit


struct ContentView: View {
    
    @State private var isLoading = false
    @State private var showingDetails = false
    
    @State var counter: Int = 0
    @State var origin: CGPoint = CGPoint(x: 0.5, y: 0.5)

    @State var movieID: String = "335984"
    @State var movieTitle: String = "Inside Out 2"
    @State var movieReleaseDate: String = "10/06/2017 (US)"
    @State var moviePoster: String = "vpnVM9B6NMmQpWeZvzLvDESb2QY.jpg"
    @State var movieBackdrop: String = "p5ozvmdgsmbWe0H8Xk7Rc8SCwAB.jpg"
    @State var movieOverview: String = "Teenager Riley's mind headquarters is undergoing a sudden demolition to make room for something entirely unexpected: new Emotions! Joy, Sadness, Anger, Fear and Disgust, who’ve long been running a successful operation by all accounts, aren’t sure how to feel when Anxiety shows up. And it looks like she’s not alone."
    
    @State var previousSuggestions:[String] = []
    
    @State var genreLabel: String = ""
    let jsonExample:String = """
{
  "title": "the title of the movie"
}
"""

    var body: some View {
        ZStack {
            
            // Background
            Color.clear
                .edgesIgnoringSafeArea(.all)
                .background(
                    AsyncImage(
                        url: URL(string: "https://image.tmdb.org/t/p/w500/\(moviePoster)"),
                        content: { image in
                            image.resizable()
                                .ignoresSafeArea()
                                .blur(radius: 50)
                                .modifier(RippleEffect(at: origin, trigger: counter))
                                .overlay(Color.black.opacity(0.5))
                        },
                        placeholder: {
                            Color.clear
                        }
                    )
                )
            
            VStack(spacing:0){
                AsyncImage(
                    url: URL(string: "https://image.tmdb.org/t/p/w500/\(moviePoster)"),
                    content: { image in
                        image.resizable()
                             .aspectRatio(contentMode: .fill)
                             .frame(width: 192, height: 296)
                             .cornerRadius(8)
                             .shadow(radius: 8, x: 0, y: 4)
                             .modifier(RippleEffect(at: origin, trigger: counter))
                             .onTapGesture {
                                 showingDetails.toggle()
                             }
                    },
                    placeholder: {
                        ProgressView()
                            .frame(width: 192, height: 296)
                    }
                )
                
                Button{
                    showingDetails.toggle()
                }label:{
                    if isLoading {
                        ProgressView()
                            .controlSize(.small)
                            .padding(.horizontal, 12)
                    } else {
                        Text("\(movieTitle)")
                            .font(.caption)
                            .fontDesign(.monospaced)
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .padding(.horizontal, 12)
                        
                    }
                }
                .frame(maxHeight:34)
                .background(
                    Capsule()
                        .fill(.thickMaterial)
                        .stroke(.white.opacity(0.14))
                )
                .foregroundStyle(.white)
                .padding()
                .sheet(isPresented: $showingDetails) {
                    MovieDetailsView(
                        movieID: $movieID,
                        movieBackdrop: $movieBackdrop,
                        movieTitle: $movieTitle,
                        movieReleaseDate: $movieReleaseDate,
                        movieOverview: $movieOverview,
                        genreLabel: $genreLabel
                    )
                    .presentationDetents([.large, .large])
                    .presentationDragIndicator(.visible)
                }
                
                GenreSelectorView(getMovieRecFromGroq: {
                    Task{
                        await getMovieRecFromGroq()
                    }
                    
                }, genreLabel: $genreLabel)

            }
            
        }
        .preferredColorScheme(.dark)
    }

    
    // Get the movie recommendation from Groq based on the selected genre
    func getMovieRecFromGroq() async {
    
        isLoading = true

        defer {
            isLoading = false
        }
        do {
            let response = try await groqService.chatCompletionRequest(body: .init(
                messages: [
                    .system(content: "Recommend a \(genreLabel) movie to watch. Respond with a single movie title and a description for why it was chosen only in json. Don't recommend any of the previous movies: \(previousSuggestions). Do not include any other content in the repsonse. Use this example json as a template: \(jsonExample). Make sure to recommend a wide variety of movies.")
                ],
                model: "llama3-8b-8192",
                responseFormat: .jsonObject
                
            ))
            let movie = response.choices.first?.message.content ?? ""
            await parseRecommendationFromGroq(movieData: movie)
        }  catch AIProxyError.unsuccessfulRequest(let statusCode, let responseBody) {
            print("Received non-200 status code: \(statusCode) with response body: \(responseBody)")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // Parse the response from Groq, set variables, the fetch data from TMDB
    func parseRecommendationFromGroq(movieData: String) async {
        
        let jsonData = movieData.data(using: .utf8)!
        
        // Decode JSON data
        if let movie = try? JSONDecoder().decode(Recommendation.self, from: jsonData) {
            movieTitle = movie.title
            previousSuggestions.append(movieTitle)
            await fetchMovieDataFromTMDB()
        }
    }
    
    // Fetch data from TMDB
    func fetchMovieDataFromTMDB() async {
        let url = URL(string: "https://api.themoviedb.org/3/search/movie")!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
          URLQueryItem(name: "query", value: movieTitle),
          URLQueryItem(name: "include_adult", value: "false"),
          URLQueryItem(name: "language", value: "en-US"),
          URLQueryItem(name: "page", value: "1"),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems

        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
          "accept": "application/json",
          "Authorization": "Bearer \(tmdb)"
        ]

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            extractMovieDataFromTMDBResponse(tmdbResponse: String(decoding: data, as: UTF8.self))
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // Parse the response from TMDB and store in state variables
    func extractMovieDataFromTMDBResponse(tmdbResponse: String) {
        // Convert JSON string to Data
        if let jsonData = tmdbResponse.data(using: .utf8) {
            do {
                // Decode JSON to MovieResponse object
                let movieResponse = try JSONDecoder().decode(MovieResponse.self, from: jsonData)
                
                // Access parsed data
                if let firstMovie = movieResponse.results.first {
                    movieID = String(firstMovie.id)
                    movieReleaseDate = firstMovie.releaseDate
                    movieOverview = firstMovie.overview
                    moviePoster = firstMovie.posterPath ?? ""
                    movieBackdrop = firstMovie.backdropPath ?? ""
                    
                    counter += 1
                }
            } catch {
                print("Failed to decode JSON:", error)
            }
        }
    }
    
}

#Preview {
    ContentView()
}
