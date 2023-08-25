//
//  RequestButton.swift
//  Kinobox
//
//  Created by Александра Кострова on 24.08.2023.
//

import UIKit

final class RequestButton: UIButton {

    var requestType: RequestType
    
    init(requestType: RequestType) {
        self.requestType = requestType 
        super.init(frame: .zero)
        
        setTitleColor(Constants.Color.lightColor, for: .normal)
        backgroundColor = Constants.Color.requestButton
        titleLabel?.font = Constants.Font.requestButton
        titleLabel?.textAlignment = .center
        layer.cornerRadius = Constants.CornerRadius.buttons
                
        switch requestType {
        case .urlSession:
            setTitle("URLSession", for: .normal)
        case .alamofire:
            setTitle("Alamofire", for: .normal)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
