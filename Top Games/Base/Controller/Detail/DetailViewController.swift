//
//  DetailViewController.swift
//  Top Games
//
//  Created by Everson Trindade on 11/05/18.
//  Copyright © 2018 Everson Trindade. All rights reserved.
//

import UIKit

class DetailViewController: UITableViewController, DetailGameLoadContent {
    
    private lazy var viewModel: DetailGameViewModelDelegate = DetailGameViewModel(delegate: self, imageId: detailDTO.image, width: view.frame.size.width)
    private var detailDTO = GameDetailDTO()
    
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var views: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
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
