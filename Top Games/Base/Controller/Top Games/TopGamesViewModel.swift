//
//  TopGamesViewModel.swift
//  Top Games
//
//  Created by Everson Trindade on 08/05/18.
//  Copyright © 2018 Everson Trindade. All rights reserved.
//

import UIKit

protocol LoadContent: class {
    func didLoadContent(error: String?)
}

protocol TopGamesViewModelPresentable: class {
    func getGames()
    func numberOfSections() -> Int
    func numberOfItemsInSection() -> Int
    func gameDTO(row: Int) -> GameDTO
}

class TopGamesViewModel: TopGamesViewModelPresentable {
    
    // MARK: properties
    weak var delegate: LoadContent?
    var interactor: TopGamesInteractorPresentable?
    var games = [Game]()
    
    // MARK: Init
    init(delegate: LoadContent?, interactor: TopGamesInteractorPresentable = TopGamesInteractor()) {
        self.delegate = delegate
        self.interactor = interactor
    }
    
    init() { }
    
    // MARK: Functions
    func getGames() {
        interactor?.getGames(offset: 0, completion: { (result, error) in
            guard let games = result else {
                self.delegate?.didLoadContent(error: error)
                return
            }
            self.games = games
            self.delegate?.didLoadContent(error: nil)
        })
    }
}

// MARK: UITableViewDTO
extension TopGamesViewModel {
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfItemsInSection() -> Int {
        return games.count
    }
    
    func gameDTO(row: Int) -> GameDTO {
        guard let game = games.object(index: row) else {
            return GameDTO()
        }
        return GameDTO(name: game.game.name)
    }
}
