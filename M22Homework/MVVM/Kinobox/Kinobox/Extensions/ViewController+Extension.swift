//
//  ViewController+Extension.swift
//  Kinobox
//
//  Created by Александра Кострова on 26.08.2023.
//

import UIKit

extension UIViewController {
    public func setMyView(_ myView: UIView, _ replaceView: UIView) {
        replaceView.addSubview(myView)
        myView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            myView.topAnchor.constraint(equalTo: replaceView.topAnchor),
            myView.leadingAnchor.constraint(equalTo: replaceView.leadingAnchor),
            myView.trailingAnchor.constraint(equalTo: replaceView.trailingAnchor),
            myView.bottomAnchor.constraint(equalTo: replaceView.bottomAnchor)
        ])
    }
}
