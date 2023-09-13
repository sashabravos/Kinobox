//
//  ViewController+Extension.swift
//  Kinobox
//
//  Created by Александра Кострова on 26.08.2023.
//

import UIKit

extension UIViewController {
    
    // MARK: - Public Methods
    
    public func makePrimaryLabel(text: String? = nil) -> UILabel {
        let label = UILabel()
        label.font = Constants.Font.primaryFont
        label.textColor = Constants.Color.darkText
        label.numberOfLines = 0
        label.text = text
        return label
    }
    
    public func makeSecondaryLabel(text: String? = nil) -> UILabel {
        let label = UILabel()
        label.font = Constants.Font.secondaryFont
        label.textColor = Constants.Color.midText
        label.numberOfLines = 0
        label.text = text
        return label
    }
    
    public func makeStackView(_ alignment: UIStackView.Alignment,
                              space: CGFloat,
                              distribution: UIStackView.Distribution,
                              views: [UIView]) -> UIStackView {
        let stackView = UIStackView()
        stackView.distribution = distribution
        stackView.axis = .vertical
        stackView.alignment = alignment
        stackView.backgroundColor = Constants.Color.background
        stackView.spacing = space
        stackView.addArrangedSubviews(views)
        return stackView
    }
}
