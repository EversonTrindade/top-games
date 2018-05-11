//
//  Game.swift
//  Top Games
//
//  Created by Everson Trindade on 09/05/18.
//  Copyright © 2018 Everson Trindade. All rights reserved.
//

import Foundation

struct Games: Decodable {
    var game: [Game]
    
    enum CodingKeys: String, CodingKey {
        case game  = "top"
    }
}

struct Game: Decodable {
    var viewers: Int
    var channels: Int
    var game: Detail
}

struct Detail: Decodable {
    var name: String
    var popularity: Int
    var _id: Int
    var giantbomb_id: Int
    var box: Box
}

struct Box: Decodable {
    var medium: String
    var large: String
}
