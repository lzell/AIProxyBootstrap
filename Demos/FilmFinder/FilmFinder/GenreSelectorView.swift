//
//  GenreSelectorView.swift
//  FilmFinder
//
//  Created by Todd Hamilton on 11/3/24.
//

import SwiftUI
import TipKit

struct GenreSelectorView: View {
    
    private let getStartedTip = GetStartedTip()
    
    private let modelSize: CGFloat = UIScreen.main.bounds.width - 40
    private let gridSize = 40  // Adjust for more dots if desired
    private let dotSize: CGFloat = 2
    private let spacing: CGFloat = 20  // Increase spacing between dots
    private let thresholdDistance: CGFloat = 75  // Max distance for attraction
    
    let getMovieRecFromGroq: () -> Void
    
    @State private var isDragging = false
    @Binding var genreLabel: String
    @State var genreScores: [String: Double] = [
        "Action": 0.0,
        "Comedy": 0.0,
        "Drama": 0.0,
        "Horror": 0.0,
        "Sci-Fi": 0.0,
        "Fantasy": 0.0,
        "Romance": 0.0,
        "Documentary": 0.0
    ]
    // Define genre centers (normalized)
    @State var genreCenters: [String: CGPoint] = [
        "Drama": CGPoint(x: 1.000, y: 0.500),
        "Horror": CGPoint(x: 0.853, y: 0.853),
        "Sci-Fi": CGPoint(x: 0.500, y: 1.000),
        "Fantasy": CGPoint(x: 0.147, y: 0.853),
        "Romance": CGPoint(x: 0.000, y: 0.500),
        "Documentary": CGPoint(x: 0.147, y: 0.147),
        "Action": CGPoint(x: 0.500, y: 0.000),
        "Comedy": CGPoint(x: 0.853, y: 0.147)
    ]
    
    @State var knobPosition: CGPoint = CGPoint(x: (UIScreen.main.bounds.width - 40) / 2, y: (UIScreen.main.bounds.width - 40) / 2)
    
    var body: some View {
        ZStack {
            
            // Drag area background
            RoundedRectangle(cornerRadius: 25)
                .fill(.thinMaterial)
                .frame(width: modelSize, height: modelSize)
                .overlay(
                    ZStack{
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(.white.opacity(0.24))
                    }
                )
                .shadow(radius: 8, x: 0, y: 4)
            
            // Dots
            GeometryReader { geo in
                let rows = Int(modelSize / spacing)
                let cols = Int(modelSize / spacing)
                
                ZStack {
                    ForEach(0..<rows, id: \.self) { row in
                        ForEach(0..<cols, id: \.self) { col in
                            Circle()
                                .fill(Color.white.opacity(dotOpacity(row: row, col: col)))
                                .frame(width: dotSize, height: dotSize)
                                .position(self.dotPosition(row: row, col: col))
                        }
                    }
                }
                .background(Color.clear)
                .padding(11)
            }
            
            // Crosshare
            Rectangle()
                .fill(LinearGradient(colors: [.clear,.clear, .white.opacity(0.24),.clear, .clear], startPoint: .leading, endPoint: .trailing))
                .frame(width: modelSize, height: 1)
                
            Rectangle()
                .fill(LinearGradient(colors: [.clear,.clear, .white.opacity(0.24), .clear, .clear], startPoint: .top, endPoint: .bottom))
                .frame(width: 1, height: modelSize)

            // Y axis labels
            VStack{
                Text("Action")
                    .foregroundStyle(genreLabel == "Action" ? .primary : .secondary)
                    .fontWeight(genreLabel == "Action" ? .bold : .regular)
                    .scaleEffect(genreLabel == "Action" ? 1.1 : 1.0)
                Spacer()
                Text("Sci-Fi")
                    .foregroundStyle(genreLabel == "Sci-Fi" ? .primary : .secondary)
                    .fontWeight(genreLabel == "Sci-Fi" ? .bold : .regular)
                    .scaleEffect(genreLabel == "Sci-Fi" ? 1.1 : 1.0)
            }
            .padding()
            .frame(width: modelSize, height: modelSize)
            
            // X axis labels
            HStack{
                Text("Romance")
                    .foregroundStyle(genreLabel == "Romance" ? .primary : .secondary)
                    .fontWeight(genreLabel == "Romance" ? .bold : .regular)
                    .scaleEffect(genreLabel == "Romance" ? 1.1 : 1.0)
                Spacer()
                Text("Drama")
                    .foregroundStyle(genreLabel == "Drama" ? .primary : .secondary)
                    .fontWeight(genreLabel == "Drama" ? .bold : .regular)
                    .scaleEffect(genreLabel == "Drama" ? 1.1 : 1.0)
            }
            .padding()
            .frame(width: modelSize, height: modelSize)
            
            // Quadrant labels
            Group {
                Text("Documentary").position(x: modelSize * 0.25, y: modelSize * 0.25)
                    .foregroundStyle(genreLabel == "Documentary" ? .primary : .secondary)
                    .fontWeight(genreLabel == "Documentary" ? .bold : .regular)
                    .scaleEffect(genreLabel == "Documentary" ? 1.1 : 1.0)
                Text("Comedy").position(x: modelSize * 0.75, y: modelSize * 0.25)
                    .foregroundStyle(genreLabel == "Comedy" ? .primary : .secondary)
                    .fontWeight(genreLabel == "Comedy" ? .bold : .regular)
                    .scaleEffect(genreLabel == "Comedy" ? 1.1 : 1.0)
                Text("Fantasy").position(x: modelSize * 0.25, y: modelSize * 0.75)
                    .foregroundStyle(genreLabel == "Fantasy" ? .primary : .secondary)
                    .fontWeight(genreLabel == "Fantasy" ? .bold : .regular)
                    .scaleEffect(genreLabel == "Fantasy" ? 1.1 : 1.0)
                Text("Horror").position(x: modelSize * 0.75, y: modelSize * 0.75)
                    .foregroundStyle(genreLabel == "Horror" ? .primary : .secondary)
                    .fontWeight(genreLabel == "Horror" ? .bold : .regular)
                    .scaleEffect(genreLabel == "Horror" ? 1.1 : 1.0)
            }
            
            // Knob to drag around
            Circle()
                .fill(Color.white.gradient)
                .stroke(.white.opacity(0.48), lineWidth:1)
                .frame(width: 40, height: 40)
                .popoverTip(getStartedTip)
                .shadow(radius: 15)
                .position(knobPosition)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            isDragging = true // Set isDragging to true when dragging starts
                            getStartedTip.invalidate(reason: .actionPerformed)
                            withAnimation(.easeOut(duration: 0.1)) {
                                // Limit position within bounds
                                knobPosition = CGPoint(
                                    x: max(0, min(modelSize, value.location.x)),
                                    y: max(0, min(modelSize, value.location.y))
                                )
                                calculateGenre()
                                calculateGenreProximityScores()
                            }
                            
                        }
                        .onEnded { _ in
                            withAnimation(.bouncy) {
                                knobPosition = CGPoint(
                                    x: modelSize / 2,
                                    y: modelSize / 2
                                )
                            }
                            // Delay setting isDragging to false until animation completes
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                withAnimation(.bouncy){
                                    isDragging = false
                                }
                                
                            }
                            getMovieRecFromGroq()
                        }
                )
            
        }
        .frame(width: modelSize, height: modelSize)
        .font(.caption2)
        .fontDesign(.monospaced)
        .preferredColorScheme(.dark)
    }
    
    // Initial grid positions with increased spacing
    private func initialDotPosition(row: Int, col: Int) -> CGPoint {
        CGPoint(x: CGFloat(col) * spacing, y: CGFloat(row) * spacing)
    }
    
    private func dotPosition(row: Int, col: Int) -> CGPoint {
        
        guard isDragging else { // Check if dragging is active
            return initialDotPosition(row: row, col: col)
        }
        
        let fingerPosition = knobPosition
        let dotPos = initialDotPosition(row: row, col: col)
        let distance = hypot(dotPos.x  - fingerPosition.x + 10, dotPos.y - fingerPosition.y + 10)
        
        if distance < thresholdDistance {
            // Calculate offset based on distance to create attraction
            let offsetFactor = (thresholdDistance - distance) / thresholdDistance
            let direction = CGPoint(x: (fingerPosition.x - dotPos.x) * offsetFactor,
                                    y: (fingerPosition.y - dotPos.y) * offsetFactor)
            return CGPoint(x: dotPos.x + direction.x, y: dotPos.y + direction.y)
        } else {
            // Outside of threshold, snap back to original position
            return dotPos
        }
    }
    
    private func dotOpacity(row: Int, col: Int) -> Double {
        
        guard isDragging else { // Only change opacity if dragging
            return 0.1
        }
        
        let fingerPosition = knobPosition
        let dotPos = initialDotPosition(row: row, col: col)
        let distance = hypot(dotPos.x - fingerPosition.x + 10, dotPos.y - fingerPosition.y + 10)

        // Calculate opacity based on proximity; closer dots are more opaque
        let opacityFactor = max(0.1, min(1.0, (thresholdDistance - distance) / thresholdDistance))
        return opacityFactor
    }
    
    // Determine the closest genre based on knob position
    private func calculateGenre() {

        // Normalize knob position
        let normalizedKnobPosition = CGPoint(x: knobPosition.x / modelSize, y: knobPosition.y / modelSize)
        
        // Find the genre with the minimum distance to the knob position
        var closestGenre: String = "Neutral"
        var minDistance: CGFloat = .greatestFiniteMagnitude
        
        for (genre, center) in genreCenters {
            let distance = hypot(normalizedKnobPosition.x - center.x, normalizedKnobPosition.y - center.y)
            if distance < minDistance {
                minDistance = distance
                closestGenre = genre
            }
        }
        
        // Update the genre label with the closest genre
        withAnimation {
            genreLabel = closestGenre
        }
    }
    

    // Calculate proximity scores for each emotion based on knob position
    private func calculateGenreProximityScores() {
        
        // Calculate proximity scores
        let normalizedKnobPosition = CGPoint(x: knobPosition.x / modelSize, y: knobPosition.y / modelSize)
        var scores: [String: Double] = [:]
        
        for (genre, center) in genreCenters {
            // Calculate inverse distance as proximity score (higher = closer)
            let distance = hypot(normalizedKnobPosition.x - center.x, normalizedKnobPosition.y - center.y)
            scores[genre] = max(0, 1 - distance) // Scale to 0-1 range
        }
    
        withAnimation(.bouncy){
            genreScores = scores
        }

    }
    
}

#Preview {
    GenreSelectorView(getMovieRecFromGroq: {}, genreLabel: .constant(""))
}
