//
//  FilmCell.swift
//  Kinobox
//
//  Created by Александра Кострова on 26.08.2023.
//

import UIKit
import SnapKit
import Kingfisher

final class FilmCell: UITableViewCell {
        
    // MARK: - Properties

    static let identifier = "FilmCell"

    private lazy var filmImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = Constants.CornerRadius.small
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = Constants.Color.midText
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private lazy var filmName: UILabel = {
        let label = UILabel()
        label.font = Constants.Font.primaryFont
        label.text = "Apple"
        label.textColor = Constants.Color.darkText
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillProportionally
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = Constants.Constraints.smallSideGap
        stackView.addArrangedSubviews([filmImageView, filmName])
        return stackView
    }()

    // MARK: - Initialisers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods

    private func setupViews() {
        self.backgroundColor = Constants.Color.background
        self.addSubview(stackView)
            stackView.snp.makeConstraints{ make in
                make.top.left.equalToSuperview().offset(Constants.Constraints.stackViewGap)
                make.bottom.right.equalToSuperview().offset(-Constants.Constraints.stackViewGap)
            }
            
        filmImageView.snp.makeConstraints { make in
            make.height.equalTo(Constants.Constraints.cellImageHeight)
            make.width.equalTo(Constants.Constraints.cellImageWidth)
        }
    }
    
    // MARK: - Public Methods

    public func configure(with model: Film) {
        filmName.text = model.nameRu
        let imageURL = URL(string: model.posterUrl ?? String())

        filmImageView.kf.indicatorType = .activity
        filmImageView.kf.setImage(
            with: imageURL,
            options: [
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage
            ]
        )
    }
}


