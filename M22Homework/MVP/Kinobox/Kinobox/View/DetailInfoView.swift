//
//  DetailInfoView.swift
//  Kinobox
//
//  Created by Александра Кострова on 09.09.2023.
//

import UIKit
import SnapKit
import Kingfisher

final class DetailInfoView: UIViewController {
    
    // MARK: - Properties
    
    var selectedFilmID: Int?
    private let presenter: DetailInfoPresenterProtocol = DetailInfoPresenter()
    
    // MARK: - Film Image
    
    private lazy var filmImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = Constants.CornerRadius.small
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = Constants.Color.midText
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    // MARK: - StackViews
    
    private lazy var rateStackView: UIStackView = {
        let stackView = makeStackView(.center,
                                      space: Constants.Constraints.stackViewGap,
                                      distribution: .fillEqually,
                                      views: [kinopoiskLabel, kinopoiskRateLabel, imdbLabel, imdbRateLabel])
        
        return stackView
    }()
    private lazy var mainStackView: UIStackView = {
        let stackView = makeStackView(.center,
                                      space: Constants.Constraints.stackViewSmallGap,
                                      distribution: .fillProportionally,
                                      views: [headerLabel, subHeaderLabel])
        return stackView
    }()
    
    private lazy var lowStackView: UIStackView = {
        let stackView = makeStackView(.leading,
                                      space: Constants.Constraints.stackViewSmallGap,
                                      distribution: .fillEqually,
                                      views: [releaseTitle, releaseYear, durationTitle, durationTime])
        return stackView
    }()
    
    // MARK: - StackView's labels
    
    private lazy var kinopoiskLabel: UILabel = {
        let label = makePrimaryLabel(text: "Kinopoisk")
        return label
    }()
    private lazy var kinopoiskRateLabel: UILabel = {
        let label = makePrimaryLabel()
        return label
    }()
    private lazy var imdbLabel: UILabel = {
        let label = makePrimaryLabel(text: "IMDB")
        return label
    }()
    private lazy var imdbRateLabel: UILabel = {
        let label = makePrimaryLabel()
        return label
    }()
    
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Font.header
        label.textColor = Constants.Color.darkText
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var subHeaderLabel: UILabel = {
        let label = makeSecondaryLabel()
        return label
    }()
    private lazy var descriptionLabel: UILabel = {
        let label = makeSecondaryLabel()
        label.textColor = .black
        return label
    }()
    private lazy var releaseTitle: UILabel = {
        let label = makeSecondaryLabel(text: "Год производства")
        return label
    }()
    private lazy var durationTitle: UILabel = {
        let label = makeSecondaryLabel(text: "Продолжительность")
        return label
    }()
    private lazy var releaseYear: UILabel = {
        let label = makeSecondaryLabel()
        label.textColor = .black
        return label
    }()
    private lazy var durationTime: UILabel = {
        let label = makeSecondaryLabel()
        label.textColor = .black
        return label
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadInfo()
        setupView()
        layoutSubViews()
        presenter.setView(self)
    }
    
    // MARK: - Private Methods
    
    private func loadInfo() {
        if let filmID = selectedFilmID {
            presenter.loadInfo(for: filmID)
        }
    }
    
    private func setupView() {
        presenter.setView(self)
        view.backgroundColor = Constants.Color.background
        [filmImageView, rateStackView, mainStackView, descriptionLabel, lowStackView].forEach {
            view.addSubview($0)
        }
    }
    
    private func layoutSubViews() {
        
        filmImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Constants.Constraints.smallSideGap)
            make.topMargin.equalToSuperview().offset(Constants.Constraints.bigVerticalGap)
            make.height.equalTo(Constants.Constraints.filmImageHeight)
            make.width.equalTo(Constants.Constraints.filmImageWidth)
        }
        
        rateStackView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-Constants.Constraints.smallSideGap)
            make.top.height.width.equalTo(filmImageView)
        }
        
        mainStackView.snp.makeConstraints { make in
            make.left.equalTo(filmImageView)
            make.right.equalTo(rateStackView)
            make.topMargin.equalTo(filmImageView.snp.bottom).offset(Constants.Constraints.stackViewGap)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.left.right.equalTo(mainStackView)
            make.topMargin.equalTo(mainStackView.snp.bottom).offset(Constants.Constraints.smallVerticalGap)
        }
        
        lowStackView.snp.makeConstraints { make in
            make.left.right.equalTo(descriptionLabel)
            make.topMargin.greaterThanOrEqualTo(descriptionLabel.snp.bottom).offset(Constants.Constraints.stackViewGap)
            make.bottom.equalToSuperview().offset(-Constants.Constraints.bigVerticalGap)
            make.height.equalTo(Constants.Constraints.lowSVHeight)
        }
    }
}

// MARK: - DetailInfoViewProtocol

extension DetailInfoView: DetailInfoViewProtocol {
        
    func configure(with model: FilmInfo) {
        
        if let ratingRu = model.ratingKinopoisk,
           let ratingWorld = model.ratingImdb,
           let header = model.nameRu,
           let subHeader = model.nameOriginal,
           let description = model.description {
            kinopoiskRateLabel.text = "\(ratingRu)"
            imdbRateLabel.text = "\(ratingWorld)"
            headerLabel.text = header
            subHeaderLabel.text = subHeader
            descriptionLabel.text = description
        }
        
        releaseYear.text = "\(model.year)"
        durationTime.text = "\(model.filmLength)"
        
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
