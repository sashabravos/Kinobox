//
//  DetailViewController.swift
//  Kinobox
//
//  Created by Александра Кострова on 26.08.2023.
//

import UIKit

final class DetailViewController: UIViewController, DetailViewDelegate {
    
    // MARK: - Instants
    
    private lazy var detailView = DetailView()
    var selectedFilmID: Int?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getInfo()
        detailView.delegate = self
        setMyView(detailView, self.view)
    }
    
    // MARK: - Private Methods
    
    private func getInfo() {
        RequestManager.shared.getFilmInfo(id: selectedFilmID ?? 1) { (result: Result<FilmInfo, Error>) in
            switch result {
            case .success(let film):
//                print(film)
                DispatchQueue.main.async { [weak self] in
                    self?.detailView.configure(with: film)
                }
            case .failure(let error):
                print("Error:", error)
            }
        }
    }
}
