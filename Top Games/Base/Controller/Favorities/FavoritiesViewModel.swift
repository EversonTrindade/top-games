//
//  FavoritiesViewModel.swift
//  Top Games
//
//  Created by Everson Trindade on 08/05/18.
//  Copyright © 2018 Everson Trindade. All rights reserved.
//

import UIKit

protocol FavoritiesLoadContent: class {
    func didLoadContent()
}

protocol FavoritiesViewModelPresentable: class {
    func numberOfSections() -> Int
    func numberOfRowsInSection() -> Int
    func heightForRow() -> CGFloat
    func numberOfGames() -> Int
    func getFavoritiesGames()
    func getFavorite(index: Int) -> FavoriteCellDTO
    func getGameDetailDTO(row: Int) -> GameDetailDTO
}

class FavoritiesViewModel: FavoritiesViewModelPresentable {

    // MARK: Properties
    weak var loadContentDelegate: FavoritiesLoadContent?
    var games = [Game]()
    
    
    // MARK: Init
    init(delegate: FavoritiesLoadContent) {
        loadContentDelegate = delegate
    }
    
    init() { }
    
    // MARK: Functions
    func getFavoritiesGames() {
        games = FavoriteManager().loadGames()
        loadContentDelegate?.didLoadContent()
    }
    
    func getFavorite(index: Int) -> FavoriteCellDTO {
        guard let favorite = games.object(index: index) else {
            return FavoriteCellDTO()
        }
        return FavoriteCellDTO(imageData: favorite.game?.imageData ?? Data(),
                               name: favorite.game?.name ?? "")
    }

}

// MARK: UITableViewDTO
extension FavoritiesViewModel {
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfRowsInSection() -> Int {
        return games.isEmpty ? 1 : games.count
    }
    
    func heightForRow() -> CGFloat{
        return 105.0
    }
    
    func numberOfGames() -> Int {
        return games.count
    }
    
    func getGameDetailDTO(row: Int) -> GameDetailDTO {
        guard let game = games.object(index: row) else {
            return GameDetailDTO()
        }        
        return GameDetailDTO(name: game.game?.name ?? "",
                             large: game.game?.box?.large ?? "",
                             viewers: game.viewers ?? 0,
                             channels: game.channels ?? 0,
                             popularity: game.game?.popularity ?? 0,
                             id: game.game?._id ?? 0,
                             giantbomb_id: game.game?.giantbomb_id ?? 0,
                             imageData: game.game?.imageData ?? Data(),
                             medium: game.game?.box?.medium ?? "")
    }

}
