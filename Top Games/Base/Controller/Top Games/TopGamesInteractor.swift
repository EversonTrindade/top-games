//
//  TopGamesInteractor.swift
//  Top Games
//
//  Created by Everson Trindade on 09/05/18.
//  Copyright © 2018 Everson Trindade. All rights reserved.
//

import Foundation

protocol TopGamesInteractorPresentable: class {
    func getGames(offset: Int, completion: @escaping (_ list: [Game]?, _ error: String?) -> ())
}

class TopGamesInteractor: TopGamesInteractorPresentable {
    func getGames(offset: Int, completion: @escaping ([Game]?, String?) -> ()) {
        GameRequest(offset: offset).request { (result, error) in
            completion(result?.game, error?.message)
        }
    }
}
