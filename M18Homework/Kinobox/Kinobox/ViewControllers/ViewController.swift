//
//  ViewController.swift
//  Kinobox
//
//  Created by Александра Кострова on 24.08.2023.
//

import UIKit
import SnapKit
import Alamofire

class ViewController: UIViewController {
    
    // MARK: - Instants
    
    private lazy var keyword = ""
    private let requestManager = RequestManager.shared
    
    // MARK: - UI Elements
    
    private lazy var requestTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter your keyword here"
        textField.textColor = Constants.Color.darkColor
        textField.font = Constants.Font.resultTextView
        textField.borderStyle = .roundedRect
        textField.clearButtonMode = .always
        return textField
    }()
    
    private lazy var urlSessionButton: RequestButton = {
        let button = RequestButton(requestType: .urlSession)
        button.addTarget(self, action: #selector(buttonTapped(sender: )), for: .touchUpInside)
        return button
    }()
    
    private lazy var alamofireButton: RequestButton = {
        let button = RequestButton(requestType: .alamofire)
        button.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var resultTextView: UITextView = {
        let textView = UITextView()
        textView.font = Constants.Font.textField
        textView.textColor = Constants.Color.darkColor
        textView.textAlignment = .left
        textView.isScrollEnabled = true
        textView.isEditable = false
        textView.isSelectable = true
        textView.layer.borderWidth = Constants.BorderLine.frameWidth
        textView.layer.cornerRadius = Constants.CornerRadius.textFields
        return textView
    }()
    
    private lazy var activityIndicator = UIActivityIndicatorView()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSubviews()
        layoutSubviews()
    }
    
    // MARK: - Actions
    
    @objc private func buttonTapped(sender: RequestButton) {
        if let word = requestTextField.text {
            keyword = word.lowercased()
        }
        
        requestManager.searchMovies(by: keyword, with: sender.requestType)
        activityIndicator.startAnimating()
        view.endEditing(true)
    }
    
    // MARK: - Adding and installing items
    
    private func setSubviews() {
        requestTextField.delegate = self
        requestManager.delegate = self
        
        view.backgroundColor = .white
        
        [requestTextField, urlSessionButton, alamofireButton, resultTextView,  activityIndicator].forEach {
            view.addSubview($0)
        }
    }
    
    private func layoutSubviews() {
        requestTextField.snp.makeConstraints { make in
            make.left.equalTo(Constants.Constraints.smallSideGap)
            make.right.equalTo(-Constants.Constraints.smallSideGap)
            make.topMargin.equalToSuperview().offset(Constants.Constraints.verticalGap)//35
        }
        
        urlSessionButton.snp.makeConstraints { make in
            make.left.equalTo(Constants.Constraints.bigSideGap)
            make.top.equalTo(requestTextField.snp.bottom).offset(Constants.Constraints.verticalGap)
            make.width.greaterThanOrEqualTo(Constants.Constraints.buttonWidth)
        }
        
        alamofireButton.snp.makeConstraints { make in
            make.right.equalTo(-Constants.Constraints.bigSideGap)
            make.top.equalTo(urlSessionButton.snp.top)
            make.width.equalTo(urlSessionButton.snp.width)
        }
        
        resultTextView.snp.makeConstraints { make in
            make.top.equalTo(urlSessionButton.snp.bottom).offset(Constants.Constraints.verticalGap)
            make.left.equalToSuperview().offset(Constants.Constraints.smallSideGap)
            make.right.equalToSuperview().offset(-Constants.Constraints.smallSideGap)
            make.bottom.equalToSuperview().offset(-Constants.Constraints.verticalGap)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(resultTextView.snp.center)
        }
    }
}

// MARK: - UITextFieldDelegate

extension ViewController: UITextFieldDelegate {
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        activityIndicator.stopAnimating()
        return true
    }
}

// MARK: - RequestResultDelegate

extension ViewController: RequestResultDelegate {
    func getResult(_ result: String) {
        DispatchQueue.main.async { [weak self] in
            self?.resultTextView.text = result
            self?.activityIndicator.stopAnimating()
        }
    }
}
