//
//  FavoriteManager.swift
//  Top Games
//
//  Created by Everson Trindade on 12/05/18.
//  Copyright © 2018 Everson Trindade. All rights reserved.
//

import Foundation
import CoreData

class FavoriteManager {
    
    class func save(favorite: Game) {
        let dataBase = LocalDataBase()
        let managedContext = dataBase.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "FavoriteGame", in: managedContext)!
        let game = NSManagedObject(entity: entity, insertInto: managedContext)
        
        game.setValue(favorite.game?.name, forKey: "name")
        game.setValue(favorite.channels, forKey: "channels")
        game.setValue(favorite.viewers, forKey: "viewers")
        game.setValue(favorite.game?.popularity, forKey: "popularity")
        game.setValue(favorite.game?._id, forKey: "id")
        game.setValue(favorite.game?.giantbomb_id, forKey: "giantbomb_id")
        game.setValue(favorite.game?.box?.large, forKey: "large")
        game.setValue(favorite.game?.box?.medium, forKey: "medium")
        game.setValue(favorite.game?.imageData, forKey: "imageData")
    
        do {
            try managedContext.save()
        } catch  {
            print("ErrorSaving")
        }
    }
    
    class func remove(favorite: Game) {
        let dataBase = LocalDataBase()
        let managedContext = dataBase.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteGame")
        if let results = try? managedContext.fetch(request) as? [FavoriteGame] {
            let game = results?.filter { Int($0.id) == favorite.game?._id }.first
            if let gameModel = game {
                managedContext.delete(gameModel)
                try? managedContext.save()
            }
        }
    }
    
    func loadGames() -> [Game] {
        let dataBase = LocalDataBase()
        let managedContext = dataBase.persistentContainer.viewContext
        var favorites = [Game]()

        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteGame")
        if let results = try? managedContext.fetch(request) as? [FavoriteGame] {
            results?.forEach { favorites.append(setFavoriteGame(with: $0)) }
        }
        return favorites
    }

    func setFavoriteGame(with object: FavoriteGame) -> Game {
        var favorite = Game()
        favorite.channels = Int(object.channels)
        favorite.viewers = Int(object.viewers)
        
        var detail = Detail()
        detail.name = object.name ?? ""
        detail._id = Int(object.id)
        detail.popularity = Int(object.popularity)
        detail.giantbomb_id = Int(object.giantbomb_id)
        detail.imageData = object.imageData
        
        var box = Box()
        box.large = object.large ?? ""
        box.medium = object.medium ?? ""
        
        detail.box = box
        favorite.game = detail
        return favorite
    }
}
