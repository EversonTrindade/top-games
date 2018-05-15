//
//  TopGameViewCell.swift
//  Top Games
//
//  Created by Everson Trindade on 09/05/18.
//  Copyright © 2018 Everson Trindade. All rights reserved.
//

import UIKit

struct GameDTO {
    var name = ""
    var image: UIImage?
    var identifier = 0
    var favorite = false
}

protocol GameCellDelegate: class {
    func didFavorite(with id: Int, shouldFavorite: Bool, imageData: Data?)
}

class TopGamesViewCell: UICollectionViewCell {
    
    // MARK: IBOutlet
    @IBOutlet weak var gameImg: UIImageView!
    @IBOutlet weak var gameNameLbl: UILabel!
    @IBOutlet weak var gameFavoriteBtn: UIButton!
    
    // MARK: Properties
    var identifier = 0
    weak var delegate: GameCellDelegate?
    var favorite = false
    
    // MARK: Functions
    func fillCell(dto: GameDTO) {
        gameNameLbl.text = dto.name
        identifier = dto.identifier
        favorite = dto.favorite
        setImage(with: dto.image)
        setFavoriteImage(favorite: dto.favorite)
    }
    
    func setImage(with image: UIImage?) {
        gameImg.image = image
        gameFavoriteBtn.setImage(UIImage(named: "favorite-set-icon"), for: .selected)
        gameFavoriteBtn.setImage(UIImage(named: "favorite-notset-icon"), for: .normal)
    }
    
    private func setFavoriteImage(favorite: Bool) {
        if favorite {
            gameFavoriteBtn.isSelected = true
        } else {
            gameFavoriteBtn.isSelected = false
        }
    }
    
    private func prepareImageData(image: UIImage?) -> Data? {
        guard let image = image, let imageData = UIImagePNGRepresentation(image) else {
            return nil
        }
        return imageData
    }
    
    // MARK: IBAction
    @IBAction func favoriteGameAction(_ sender: UIButton) {
        delegate?.didFavorite(with: identifier,
                              shouldFavorite: !gameFavoriteBtn.isSelected,
                              imageData: prepareImageData(image: gameImg.image))
        setFavoriteImage(favorite: !gameFavoriteBtn.isSelected)
    }
}
