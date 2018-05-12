//
//  FavoritiesViewModel.swift
//  Top Games
//
//  Created by Everson Trindade on 08/05/18.
//  Copyright © 2018 Everson Trindade. All rights reserved.
//

import UIKit

protocol FavoritiesLoadContent: class {

}

protocol FavoritiesViewModelPresentable: class {
    func numberOfSections() -> Int
    func numberOfRowsInSection() -> Int
    func heightForRow() -> CGFloat
    func numberOfGames() -> Int
}

class FavoritiesViewModel: FavoritiesViewModelPresentable {

    // MARK: Properties
    weak var loadContentDelegate: FavoritiesLoadContent?
    var games = [Game]()
    
    
    // MARK: Init
    init(delegate: FavoritiesLoadContent) {
        loadContentDelegate = delegate
    }

}

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
}
