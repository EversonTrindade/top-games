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
    
    @IBOutlet weak var gameImg: UIImageView!
    @IBOutlet weak var gameName: UILabel!
    
    func fillCell(dto: FavoriteCellDTO) {
        gameImg.image = UIImage(data: dto.imageData)
        gameName.text = dto.name
    }
}
