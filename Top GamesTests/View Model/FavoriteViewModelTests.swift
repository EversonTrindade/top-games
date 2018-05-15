//
//  FavoriteViewModelTests.swift
//  Top GamesTests
//
//  Created by Everson Trindade on 15/05/18.
//  Copyright © 2018 Everson Trindade. All rights reserved.
//

import XCTest
@testable import Top_Games

class FavoriteViewModelTests: XCTestCase {
    
    let viewModel = FavoritiesViewModel()
    
    override func setUp() {
        super.setUp()
       
        guard let mocket = readJSON(name: "Mock"), let games = try? JSONDecoder().decode(Games.self, from: mocket) else {
            return
        }
        viewModel.games = games.game
    }
    
    func testShouldValidateNumberOfSections() {
        XCTAssert(viewModel.numberOfSections() == 1)
    }
    
    func testShouldValidateNumberOfRows() {
        XCTAssert(viewModel.numberOfGames() == 10)
    }
    
    func testShouldValidateHeigthForRow() {
        XCTAssert(viewModel.heightForRow() == 105.0)
    }
    
    func testShouldValidateNumberGames() {
        XCTAssert(viewModel.numberOfGames() == 10)
    }
    
    func testShouldValidateGetGameDetailDTO() {
        XCTAssert(viewModel.getGameDetailDTO(row: 0).large == "https://static-cdn.jtvnw.net/ttv-boxart/Overwatch-272x380.jpg")
        XCTAssert(viewModel.getGameDetailDTO(row: 0).name == "Overwatch")
        XCTAssert(viewModel.getGameDetailDTO(row: 0).viewers == 19251)
        XCTAssert(viewModel.getGameDetailDTO(row: 0).channels == 1399)
        XCTAssert(viewModel.getGameDetailDTO(row: 0).popularity == 19100)
        XCTAssert(viewModel.getGameDetailDTO(row: 0).id == 488552)
        XCTAssert(viewModel.getGameDetailDTO(row: 0).giantbomb_id == 48190)
        XCTAssert(viewModel.getGameDetailDTO(row: 0).medium == "https://static-cdn.jtvnw.net/ttv-boxart/Overwatch-136x190.jpg")
    }
}
