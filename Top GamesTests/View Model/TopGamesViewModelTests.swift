//
//  TopGamesViewModelTests.swift
//  Top GamesTests
//
//  Created by Everson Trindade on 11/05/18.
//  Copyright © 2018 Everson Trindade. All rights reserved.
//

import XCTest
@testable import Top_Games

extension XCTestCase {
    func readJSON(name: String) -> Data? {
        let path = Bundle.main.path(forResource: name, ofType: "json")
        let data = try! Data(contentsOf: URL(fileURLWithPath: path!))
        return data
    }
}

class TopGamesViewModelTests: XCTestCase {
    
    let viewModel = TopGamesViewModel()
    
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
    
    func testShouldValidateNumberOfItems() {
        XCTAssert(viewModel.numberOfItemsInSection() == 10)
    }
    
    func testShouldValidateMinimumInteritemSpacing() {
        XCTAssert(viewModel.minimumInteritemSpacingForSectionAt() == 8.0)
    }
    
    func testShouldValidateGetGameDTO() {
        XCTAssert(viewModel.gameDTO(row: 0).name == "Overwatch")
        XCTAssert(viewModel.gameDTO(row: 0).identifier == "https://static-cdn.jtvnw.net/ttv-boxart/Overwatch-136x190.jpg")
    }
    
    func testShouldValidateGetGameDetailDTO() {
        XCTAssert(viewModel.getGameDetailDTO(row: 0).image == "https://static-cdn.jtvnw.net/ttv-boxart/Overwatch-272x380.jpg")
        XCTAssert(viewModel.getGameDetailDTO(row: 0).name == "Overwatch")
        XCTAssert(viewModel.getGameDetailDTO(row: 0).views == 19251)
    }
}
