//
//  DetailViewController.swift
//  Top Games
//
//  Created by Everson Trindade on 11/05/18.
//  Copyright © 2018 Everson Trindade. All rights reserved.
//

import UIKit

class DetailViewController: UITableViewController, DetailGameLoadContent {
    
    //MARK: Properties
    private lazy var viewModel: DetailGameViewModelPresentable = DetailGameViewModel(delegate: self, imageId: detailDTO.large)
    private var detailDTO = GameDetailDTO()
//    let favoriteButton = UIBarButtonItem(image: UIImage(named: "favorite-notset-icon"),
//                                         style: .plain,
//                                         target: self,
//                                         action: #selector(DetailViewController.favoriteGame(_:)))
    
    private var favoriteButton = UIBarButtonItem()
    
    // MARK: IBOutlet
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var views: UILabel!
    
    // MARK: ViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        populate()
        viewModel.getFavorites()
        formatNavigationBar()
    }
    
    // MARK: Methods
    private func populate() {
        name.text = detailDTO.name
        views.text = "Viewers: \(detailDTO.viewers)"
        poster.image = viewModel.getImage()
    }
    
    func formatNavigationBar() {
        navigationItem.title = detailDTO.name
        favoriteButton = UIBarButtonItem(image: UIImage(named: "favorite-notset-icon"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(favoriteGameFromDetail))
        
        favoriteButton.tintColor = UIColor.red
        
        
        if viewModel.isFavorite(id: detailDTO.id) {
            favoriteButton.image = UIImage(named: "favorite-set-icon")
        }
        
        navigationItem.rightBarButtonItems = [favoriteButton]
    }
    
    @objc func favoriteGameFromDetail() {
        if viewModel.favoriteGame(dto: detailDTO) {
            favoriteButton.image = UIImage(named: "favorite-set-icon")
        } else {
            favoriteButton.image = UIImage(named: "favorite-notset-icon")
        }
    }
    
    func fill(with dto: GameDetailDTO) {
        detailDTO = dto
    }
    
    // MARK: - DetailGameLoadContent
    func didLoadImage() {
        poster.image = viewModel.imageFromCache()
    }
}
