//
//  GameTests.swift
//  Top GamesTests
//
//  Created by Everson Trindade on 11/05/18.
//  Copyright © 2018 Everson Trindade. All rights reserved.
//

import XCTest
@testable import Top_Games

class GameTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    
    //JSONDecoder().decode(Games.self, from: dataFromService)
    func testShouldValidateGameResult() {
        guard let mocket = readJSON(name: "Mock"), let games = try? JSONDecoder().decode(Games.self, from: mocket) else {
            return
        }
        
        XCTAssert(games.game.object(index: 0)?.viewers == 19251)
        XCTAssert(games.game.object(index: 0)?.channels == 1399)
        XCTAssert(games.game.object(index: 0)?.game._id == 488552)
        XCTAssert(games.game.object(index: 0)?.game.giantbomb_id == 48190)
        XCTAssert(games.game.object(index: 0)?.game.name == "Overwatch")
        XCTAssert(games.game.object(index: 0)?.game.popularity == 19100)
        XCTAssert(games.game.object(index: 0)?.game.box.large == "https://static-cdn.jtvnw.net/ttv-boxart/Overwatch-272x380.jpg")
        XCTAssert(games.game.object(index: 0)?.game.box.medium == "https://static-cdn.jtvnw.net/ttv-boxart/Overwatch-136x190.jpg")
        
    }
   
    
}
