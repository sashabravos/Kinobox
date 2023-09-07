//
//  SearchViews.swift
//  Kinobox
//
//  Created by Александра Кострова on 26.08.2023.
//

import UIKit
import SnapKit
import Kingfisher

// MARK: - SearchViewDelegate

protocol SearchViewDelegate: AnyObject {
}

final class SearchView: UIView {
    
    // MARK: - Instants
    
    weak var delegate: SearchViewDelegate?
    lazy var filmsArray = [Film]()
    lazy var sectionTitle = "Section title"
    
    // MARK: - UI Elements
    
    lazy var requestTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите слово для поиска"
        textField.textColor = Constants.Color.darkText
        textField.font = Constants.Font.secondaryFont
        textField.borderStyle = .roundedRect
        textField.clearButtonMode = .always
        return textField
    }()
    
    lazy var searchButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(Constants.Color.lightText, for: .normal)
        button.backgroundColor = Constants.Color.searchButton
        button.titleLabel?.font = Constants.Font.primaryFont
        button.titleLabel?.textAlignment = .center
        button.layer.borderColor = Constants.Color.borderLine
        button.layer.borderWidth = Constants.BorderLine.frameWidth
        button.layer.cornerRadius = Constants.CornerRadius.big
        button.setTitle("Поиск", for: .normal)
        return button
    }()
    
    lazy var topFilmsButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(Constants.Color.lightText, for: .normal)
        button.backgroundColor = Constants.Color.topFilmsButton
        button.titleLabel?.font = Constants.Font.primaryFont
        button.titleLabel?.textAlignment = .center
        button.layer.borderColor = Constants.Color.borderLine
        button.layer.borderWidth = Constants.BorderLine.frameWidth
        button.layer.cornerRadius = Constants.CornerRadius.big
        button.setTitle("Популярные фильмы", for: .normal)
        return button
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = Constants.Color.background
        tableView.register(FilmCell.self, forCellReuseIdentifier: FilmCell.identifier)
        return tableView
    }()
    
    lazy var activityIndicator = UIActivityIndicatorView()
    
    // MARK: - Initialisation
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setSubviews()
        layoutSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    private func setSubviews() {
        tableView.dataSource = self
        tableView.delegate = self
        requestTextField.delegate = self
        
        self.backgroundColor = Constants.Color.background
        
        [requestTextField, searchButton, topFilmsButton, tableView, activityIndicator].forEach {
            self.addSubview($0)
        }
    }
    
    private func layoutSubViews() {
        requestTextField.snp.makeConstraints { make in
            make.left.equalTo(Constants.Constraints.smallSideGap)
            make.right.equalTo(-Constants.Constraints.smallSideGap)
            make.topMargin.equalToSuperview().offset(Constants.Constraints.bigVerticalGap)
        }
        
        searchButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(requestTextField.snp.bottom).offset(Constants.Constraints.smallVerticalGap)
            make.width.greaterThanOrEqualTo(Constants.Constraints.searchButtonWidth)
        }
        
        topFilmsButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(searchButton.snp.bottom).offset(Constants.Constraints.smallVerticalGap)
            make.width.greaterThanOrEqualTo(Constants.Constraints.topFilmsButtonWidth)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(topFilmsButton.snp.bottom).offset(Constants.Constraints.smallVerticalGap)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(tableView.snp.center)
        }
    }
}

// MARK: - UITableViewDataSource

extension SearchView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filmsArray.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let filmCell = tableView.dequeueReusableCell(
            withIdentifier: FilmCell.identifier,
            for: indexPath) as! FilmCell
        
        let film = filmsArray[indexPath.row]
        filmCell.configure(with: film)
        return filmCell
    }
}

// MARK: - UITableViewDelegate

extension SearchView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedFilm = filmsArray[indexPath.row]
        let detailInfo = DetailViewController()
        detailInfo.selectedFilmID = selectedFilm.filmId
        if let parentViewController = parentViewController {
            parentViewController.present(detailInfo, animated: true)
        }
    }
}

// MARK: - UITextFieldDelegate

extension SearchView: UITextFieldDelegate {
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        activityIndicator.stopAnimating()
        return true
    }
}
