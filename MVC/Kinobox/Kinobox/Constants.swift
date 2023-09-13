//
//  Constants.swift
//  Kinobox
//
//  Created by Александра Кострова on 24.08.2023.
//

import UIKit

enum Constants {
    
    enum Color {
        static let darkText = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        static let lightText = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        static let midText = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        
        static let background = #colorLiteral(red: 0.9764705882, green: 0.9764705882, blue: 0.9764705882, alpha: 1)
        static let searchButton = #colorLiteral(red: 0.9699966311, green: 0.2431964278, blue: 0.1119191721, alpha: 1)
        static let topFilmsButton = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        static let borderLine: CGColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }
    
    enum Font {
        // Universal
        static let primaryFont = UIFont.systemFont(ofSize: 22.0)
        static let secondaryFont = UIFont.systemFont(ofSize: 20.0)
        
        // DetailView
        static let header = UIFont.boldSystemFont(ofSize: 26.0)
    }
    
    enum Constraints {
        // SearchVC
        static let searchButtonWidth = 100.0
        static let topFilmsButtonWidth = 250.0
        
        static let smallSideGap = 25.0
        static let bigSideGap = 35.0
        static let smallVerticalGap = 20.0
        static let bigVerticalGap = 30.0
        
        // FilmCell
        static let stackViewGap = 10.0
        static let cellImageHeight = 85.0
        static let cellImageWidth = 65.0
        
        // DetailView
        static let stackViewSmallGap = 5.0
        static let filmImageHeight = 220.0
        static let filmImageWidth = 165.0
        static let lowSVHeight = 120.0
    }
    
    enum CornerRadius {
        static let small = 5.0
        static let big = 10.0
    }
    
    enum BorderLine {
        static let frameWidth = 0.5
    }
    
    enum Link {
        static let filmsURL = "https://kinopoiskapiunofficial.tech/api/v2.1/films/"
        static let detailURL = "https://kinopoiskapiunofficial.tech/api/v2.2/films/"
        static let searchByKeywordURL = filmsURL + "search-by-keyword?keyword"
        static let topFilmsURL = filmsURL + "top?type"
    }
    enum Keys {
        static let apiKey = "914256ab-fd14-4484-a7d8-f89961c9f581"
    }
}
