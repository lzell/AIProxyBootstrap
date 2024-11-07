//
//  GetStartedTip.swift
//  FilmFinder
//
//  Created by Todd Hamilton on 10/31/24.
//

import SwiftUI
import TipKit

// Tooltip for first time users
struct GetStartedTip: Tip {
    var title: Text {
        Text("Get movie recommendations")
    }
    var message: Text? {
        Text("Drag the circle to choose a genre.")
    }
}
