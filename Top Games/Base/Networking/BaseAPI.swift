//
//  BaseAPI.swift
//  Top Games
//
//  Created by Everson Trindade on 08/05/18.
//  Copyright © 2018 Everson Trindade. All rights reserved.
//

import Foundation

protocol Mappable: Codable, Equatable {
    init?(data: Data)
}

protocol Requestable: class {
    associatedtype DataType
    func request(completion: @escaping (_ result: DataType?, _ error: CustomError?) -> Void)
}

struct BaseAPI {
    static let client_id = "85wkm4h30lmzldarfokxx7pu0v0c7d"
    fileprivate let base = "https://api.twitch.tv/kraken/"
    var games: String {
        return base + "games/top"
    }
}
