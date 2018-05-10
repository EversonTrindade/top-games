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
    func didLoadImage(identifier: String)
}

protocol TopGamesViewModelPresentable: class {
    func getGames()
    func numberOfSections() -> Int
    func numberOfItemsInSection() -> Int
    func gameDTO(row: Int) -> GameDTO
    func sizeForItems(with width: CGFloat, height: CGFloat) -> CGSize
    func minimumInteritemSpacingForSectionAt() -> CGFloat
    func imageFromCache(identifier: String) -> UIImage?
}

class TopGamesViewModel: TopGamesViewModelPresentable {
    
    // MARK: properties
    weak var delegate: LoadContent?
    var interactor: TopGamesInteractorPresentable?
    var games = [Game]()
    private var cache = NSCache<NSString, UIImage>()
    
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
    
    func getImage(urlString: String) -> UIImage {
        
        let placeholder = UIImage(named: "icon-placeholder")
        placeholder?.accessibilityIdentifier = "placeholder"
        if urlString.isEmpty {
            cache.setObject(placeholder ?? UIImage(), forKey: NSString(string: urlString))
        }
        
        if let cachedImage = cache.object(forKey: NSString(string: urlString)) {
            return cachedImage
        }
        
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url, completionHandler: { data, _, _ in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.cache.setObject(image, forKey: NSString(string: urlString))
                        self.delegate?.didLoadImage(identifier: urlString)
                    }
                }
            }).resume()
        }
        return UIImage()
    }
    
    func imageFromCache(identifier: String) -> UIImage? {
        return cache.object(forKey: NSString(string: identifier))
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
        return GameDTO(name: game.game.name,
                       image: getImage(urlString: game.game.box.medium),
                       identifier: game.game.box.medium)
    }
    
    func sizeForItems(with width: CGFloat, height: CGFloat) -> CGSize {
        return CGSize(width: ((width / 2) - 12), height: ((height / 2) - 12))
    }
    
    func minimumInteritemSpacingForSectionAt() -> CGFloat {
        return 8.0
    }

}
