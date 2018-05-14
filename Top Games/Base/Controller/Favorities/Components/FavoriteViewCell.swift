//
//  FavoriteViewCell.swift
//  Top Games
//
//  Created by Everson Trindade on 12/05/18.
//  Copyright © 2018 Everson Trindade. All rights reserved.
//

import UIKit

struct FavoriteCellDTO {
    var imageData = Data()
    var name = ""
}

class FavoriteViewCell: UITableViewCell {
    
    @IBOutlet weak var movieImg: UIImageView!
    @IBOutlet weak var movieName: UILabel!
    
    func fillCell(dto: FavoriteCellDTO) {
        movieImg.image = UIImage(data: dto.imageData)
        movieName.text = dto.name
    }
}
