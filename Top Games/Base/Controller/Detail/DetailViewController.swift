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
    private lazy var viewModel: DetailGameViewModelPresentable = DetailGameViewModel(delegate: self, imageId: detailDTO.image)
    private var detailDTO = GameDetailDTO()
    
    // MARK: IBOutlet
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var views: UILabel!
    
    // MARK: ViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        populate()
    }
    
    // MARK: Methods
    private func populate() {
        navigationItem.title = detailDTO.name
        name.text = detailDTO.name
        views.text = "Viewers: \(detailDTO.views)"
        poster.image = viewModel.getImage()
    }
    
    func fill(with dto: GameDetailDTO) {
        detailDTO = dto
    }
    
    // MARK: - DetailGameLoadContent
    func didLoadImage() {
        poster.image = viewModel.imageFromCache()
    }
}
