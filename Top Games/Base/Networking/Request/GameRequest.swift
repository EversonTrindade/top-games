//
//  GameRequest.swift
//  Top Games
//
//  Created by Everson Trindade on 09/05/18.
//  Copyright © 2018 Everson Trindade. All rights reserved.
//

import Foundation

class GameRequest: Requestable {
    
    fileprivate var offset = 0
    
    init(offset: Int) {
        self.offset = offset
    }
    
    func request(completion: @escaping (Games?, CustomError?) -> Void) {
        var urlComponents = URLComponents(string: BaseAPI().games)
        urlComponents?.queryItems = [URLQueryItem(name: "limit", value: "20"),
                                     URLQueryItem(name: "offset", value: "\(offset)")]
        
        guard let url = urlComponents?.url else {
            completion(nil, CustomError())
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue(BaseAPI.client_id, forHTTPHeaderField: "client-id")
        
        URLSession.shared.dataTask(with: request) { data, response, error  in
            if let error = error {
                completion(nil, CustomError(error: error.localizedDescription as? Error))
                return
            }
            guard let dataFromService = data else {
                completion(nil, CustomError())
                return
            }
            guard let games = try? JSONDecoder().decode(Games.self, from: dataFromService) else {
                completion(nil, CustomError())
                return
            }
            completion(games, nil)
        }.resume()
    }
}
