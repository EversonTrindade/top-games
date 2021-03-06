//
//  TopGamesViewModel.swift
//  Top Games
//
//  Created by Everson Trindade on 08/05/18.
//  Copyright © 2018 Everson Trindade. All rights reserved.
//

import UIKit
import AudioToolbox
import CoreData

protocol LoadContent: class {
    func didLoadContent(error: String?)
    func didLoadImage(identifier: Int)
}

protocol TopGamesViewModelPresentable: class {
    
    var canLoad: Bool { get }
    
    func getGames()
    func numberOfSections() -> Int
    func numberOfItemsInSection() -> Int
    func gameDTO(row: Int) -> GameDTO
    func sizeForItems(with width: CGFloat, height: CGFloat) -> CGSize
    func minimumInteritemSpacingForSectionAt() -> CGFloat
    func imageFromCache(identifier: Int) -> UIImage?
    func updateSearchResults(for searchController: UISearchController)
    func getGameDetailDTO(row: Int) -> GameDetailDTO
    func refresh()
    func didFavorite(with id: Int, shouldFavorite: Bool, imageData: Data?)
    func getFavorites()
    func eraseData()
    func setSearchBarActive()
}

class TopGamesViewModel: TopGamesViewModelPresentable {

    // MARK: properties
    weak var delegate: LoadContent?
    var interactor: TopGamesInteractorPresentable?
    var games = [Game]()
    var filteredGames = [Game]()
    var favorites = [Game]()
    private var cache = NSCache<NSString, UIImage>()
    var canLoad = true
    var searchBarIsActive = false
    
    // MARK: Init
    init(delegate: LoadContent?, interactor: TopGamesInteractorPresentable = TopGamesInteractor()) {
        self.delegate = delegate
        self.interactor = interactor
    }
    
    init() { }
    
    // MARK: Functions
    func getGames() {
        if canLoad && !searchBarIsActive{
            canLoad = false
            interactor?.getGames(offset: self.games.count, completion: { (result, error) in
                guard let games = result else {
                    self.delegate?.didLoadContent(error: error)
                    return
                }
                self.games = self.games + games
                self.canLoad = true
                self.delegate?.didLoadContent(error: nil)
                self.saveDataToWidget()
            })
        }
    }
    
    func refresh() {
        games = [Game]()
        filteredGames = [Game]()
        canLoad = true
        getGames()
        getFavorites()
        searchBarIsActive = false
    }
    
    func getImage(urlString: String, id: Int) -> UIImage {
        
        let placeholder = UIImage(named: "icon-placeholder")
        placeholder?.accessibilityIdentifier = "placeholder"
        if urlString.isEmpty {
            cache.setObject(placeholder ?? UIImage(), forKey: NSString(string: urlString))
        }
        
        if let cachedImage = cache.object(forKey: NSString(string: "\(id)")) {
            return cachedImage
        }
        
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url, completionHandler: { data, _, _ in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.cache.setObject(image, forKey: NSString(string: "\(id)"))
                        self.delegate?.didLoadImage(identifier: id)
                    }
                }
            }).resume()
        }
        return UIImage()
    }
    
    func imageFromCache(identifier: Int) -> UIImage? {
        return cache.object(forKey: NSString(string: "\(identifier)"))
    }
    
    func saveDataToWidget() {
        let sharedDefaults = UserDefaults(suiteName: "group.sharingDataForTodayWidget")
        for index in 0...2 {
            let name = games.object(index: index)?.game?.name
            let image = games.object(index: index)?.game?.box?.medium
            sharedDefaults?.setValue(name, forKey: "gameName\(index)")
            sharedDefaults?.setValue(image, forKey: "gameImage\(index)")
        }
    }
    
    func didFavorite(with id: Int, shouldFavorite: Bool, imageData: Data?) {
        let pop = SystemSoundID(1520)
        AudioServicesPlaySystemSound(pop)
        
        let array = games.filter { id == $0.game?._id }
        guard let game = array.first else {
            return
        }
        
        var favorite = game
        favorite.game?.imageData = imageData ?? Data().base64EncodedData()
        
        if shouldFavorite {
            FavoriteManager.save(favorite: favorite)
        } else {
            FavoriteManager.remove(favorite: favorite)
        }
    }
    
    func getFavorites() {
        favorites = FavoriteManager().loadGames()
    }
    
    func isFavorite(id: Int) -> Bool {
        return favorites.filter { $0.game?._id == id }.count > 0
    }
    
    private func prepareImageData(image: UIImage?) -> Data? {
        guard let image = image, let imageData = UIImagePNGRepresentation(image) else {
            return nil
        }
        return imageData
    }
    
    func eraseData() {
        games = [Game]()
        filteredGames = [Game]()
        favorites = [Game]()
    }
    
    func setSearchBarActive() {
        searchBarIsActive = false
    }
}

// MARK: UICollectionViewDTO
extension TopGamesViewModel {
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfItemsInSection() -> Int {
        return searchBarIsActive ? filteredGames.count : games.count
    }
    
    func gameDTO(row: Int) -> GameDTO {
        if searchBarIsActive {
            guard let game = filteredGames.object(index: row) else {
                return GameDTO()
            }
            return GameDTO(name: game.game?.name ?? "",
                           image: getImage(urlString: game.game?.box?.large ?? "", id: game.game?._id ?? 0),
                           identifier: game.game?._id ?? 0,
                           favorite: isFavorite(id: game.game?._id ?? 0))

        } else {
            guard let game = games.object(index: row) else {
                return GameDTO()
            }
            return GameDTO(name: game.game?.name ?? "",
                           image: getImage(urlString: game.game?.box?.large ?? "", id: game.game?._id ?? 0),
                           identifier: game.game?._id ?? 0,
                           favorite: isFavorite(id: game.game?._id ?? 0))

        }
    }
    
    func getGameDetailDTO(row: Int) -> GameDetailDTO {
        if searchBarIsActive {
            guard let game = filteredGames.object(index: row) else {
                return GameDetailDTO()
            }
            return GameDetailDTO(name: game.game?.name ?? "",
                                 large: game.game?.box?.large ?? "",
                                 viewers: game.viewers ?? 0,
                                 channels: game.channels ?? 0,
                                 popularity: game.game?.popularity ?? 0,
                                 id: game.game?._id ?? 0,
                                 giantbomb_id: game.game?.giantbomb_id ?? 0,
                                 imageData: prepareImageData(image: getImage(urlString: game.game?.box?.large ?? "", id: game.game?._id ?? 0)) ?? Data(),
                                 medium: game.game?.box?.medium ?? "")
        } else {
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
                                 imageData: prepareImageData(image: getImage(urlString: game.game?.box?.large ?? "", id: game.game?._id ?? 0)) ?? Data(),
                                 medium: game.game?.box?.medium ?? "")
        }
    }
    
    func sizeForItems(with width: CGFloat, height: CGFloat) -> CGSize {
        return CGSize(width: ((width / 2) - 12), height: ((height / 2) - 12))
    }
    
    func minimumInteritemSpacingForSectionAt() -> CGFloat {
        return 8.0
    }
}

// MARK Search Bar
extension TopGamesViewModel {
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.isActive {
            searchBarIsActive = true
            if let searchText = searchController.searchBar.text {
                self.filteredGames = searchText.isEmpty ? games : games.filter({ (item) -> Bool in
                    print(self.filteredGames.count)
                    return item.game?.name?.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
                })
            }
        } else {
            searchBarIsActive = false
        }
    }
}
