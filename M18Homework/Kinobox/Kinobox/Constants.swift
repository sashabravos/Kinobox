//
//  Constants.swift
//  Kinobox
//
//  Created by Александра Кострова on 24.08.2023.
//

import UIKit

enum Constants {
    
    enum Color {
        static let requestButton = UIColor.systemIndigo
        static let darkColor = UIColor.black
        static let lightColor = UIColor.white
    }
    
    enum Font {
        static let textField = UIFont.systemFont(ofSize: 20.0)
        static let resultTextView = UIFont.systemFont(ofSize: 26.0)
        static let requestButton = UIFont.systemFont(ofSize: 22.0)
    }
    
    enum Constraints {
        static let buttonWidth = 150.0
        
        static let smallSideGap = 25.0
        static let bigSideGap = 35.0
        static let verticalGap = 35.0
    }
    
    enum CornerRadius {
        static let textFields = 5.0
        static let buttons = 10.0
    }
    
    enum BorderLine {
        static let frameWidth = 1.0
    }
    
    enum Keys {
        static let apiKey = "914256ab-fd14-4484-a7d8-f89961c9f581"
    }
}
