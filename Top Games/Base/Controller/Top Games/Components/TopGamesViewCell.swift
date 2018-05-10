//
//  TopGameViewCell.swift
//  Top Games
//
//  Created by Everson Trindade on 09/05/18.
//  Copyright © 2018 Everson Trindade. All rights reserved.
//

import UIKit

struct GameDTO {
//    var id = 0
    var name = ""
//    var image: UIImage?
//    var identifier = ""
//    var favorite = false
}

class TopGamesViewCell: UICollectionViewCell {
    
    @IBOutlet weak var gameImg: UIImageView!
    @IBOutlet weak var gameNameLbl: UILabel!
    
    func fillCell(dto: GameDTO) {
        gameNameLbl.text = dto.name
    }
}
