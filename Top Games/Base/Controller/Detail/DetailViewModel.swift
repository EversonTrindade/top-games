//
//  DetailViewModel.swift
//  Top Games
//
//  Created by Everson Trindade on 11/05/18.
//  Copyright © 2018 Everson Trindade. All rights reserved.
//

import Foundation
import UIKit

struct GameDetailDTO {
    var name = ""
    var large = ""
    var viewers = 0
    var channels = 0
    var popularity = 0
    var id = 0
    var giantbomb_id = 0
    var imageData = Data()
    var medium = ""
}

protocol DetailGameLoadContent: class {
    func didLoadImage()
}

protocol DetailGameViewModelPresentable: class {
    func getImage() -> UIImage?
    func imageFromCache() -> UIImage?
    func favoriteGame(dto: GameDetailDTO) -> Bool
    func getFavorites()
    func isFavorite(id: Int) -> Bool
}

class DetailGameViewModel: DetailGameViewModelPresentable {
    
    // MARK: Propertiers
    private var imageId = ""
    weak var loadContentDelegate: DetailGameLoadContent?
    private var cache = NSCache<NSString, UIImage>()
    var favorites = [Game]()
    
    // MARK: Init
    init(delegate: DetailGameLoadContent, imageId: String) {
        loadContentDelegate = delegate
        self.imageId = imageId
    }
    
    // MARK: - CachedImageLoadContent
    func getImage() -> UIImage? {
        if let imageCached = cache.object(forKey: NSString(string: imageId)) {
            return imageCached
        }
        
        let placeholder = UIImage(named: "icon-placeholder")
        placeholder?.accessibilityIdentifier = "placeholder"
        cache.setObject(placeholder ?? UIImage(), forKey: NSString(string: imageId))
        
        if let url = URL(string: imageId) {
            URLSession.shared.dataTask(with: url, completionHandler: { data, _, _ in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.cache.setObject(image, forKey: NSString(string: self.imageId))
                        self.loadContentDelegate?.didLoadImage()
                    }
                }
            }).resume()
        }
        return nil
    }
    
    func imageFromCache() -> UIImage? {
        return cache.object(forKey: NSString(string: imageId))
    }
    
    // MARK: Functions
    func getFavorites() {
        favorites = FavoriteManager().loadGames()
    }
    
    func favoriteGame(dto: GameDetailDTO) -> Bool {
        getFavorites()
        if isFavorite(id: dto.id) {
            FavoriteManager.remove(favorite: formatGame(dto: dto))
            return false
        } else {
            FavoriteManager.save(favorite: formatGame(dto: dto))
            return true
        }
    }

    func isFavorite(id: Int) -> Bool {
        return favorites.filter { $0.game?._id == id }.count > 0
    }
    
    func formatGame(dto: GameDetailDTO) -> Game {
        var favorite = Game()
        favorite.channels = dto.channels
        favorite.viewers = dto.viewers
        
        var detail = Detail()
        detail.name = dto.name
        detail._id = dto.id
        detail.popularity = dto.popularity
        detail.giantbomb_id = dto.giantbomb_id
        detail.imageData = dto.imageData
        
        var box = Box()
        box.large = dto.large
        box.medium = dto.medium
        
        detail.box = box
        favorite.game = detail
        return favorite
    }
    
}
