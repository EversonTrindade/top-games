//
//  TodayViewController.swift
//  GamesWidget
//
//  Created by Everson Trindade on 12/05/18.
//  Copyright © 2018 Everson Trindade. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding, TodayLoadContent {
    
    @IBOutlet weak var firstGameLbl: UILabel!
    @IBOutlet weak var secondGameLbl: UILabel!
    @IBOutlet weak var thirdGameLbl: UILabel!
    @IBOutlet weak var firstGameImg: UIImageView!
    @IBOutlet weak var secondGameImg: UIImageView!
    @IBOutlet weak var thirdGameImg: UIImageView!
    
    lazy var viewModel: TodayViewModelPresentable = TodayViewModel(delegate: self)
    var gameImage0: String?
    var gameImage1: String?
    var gameImage2: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showDataInWidget()
    }
    
    func showDataInWidget() {
        let sharedDefaults = UserDefaults.init(suiteName: "group.sharingDataForTodayWidget")
        firstGameLbl.text = sharedDefaults?.value(forKey: "gameName0") as? String
        secondGameLbl.text = sharedDefaults?.value(forKey: "gameName1") as? String
        thirdGameLbl.text = sharedDefaults?.value(forKey: "gameName2") as? String
        
        gameImage0 = sharedDefaults?.value(forKey: "gameImage0") as? String
        gameImage1 = sharedDefaults?.value(forKey: "gameImage1") as? String
        gameImage2 = sharedDefaults?.value(forKey: "gameImage2") as? String
        
        firstGameImg.image = viewModel.getImage(urlString: gameImage0 ?? "")
        secondGameImg.image = viewModel.getImage(urlString: gameImage1 ?? "")
        thirdGameImg.image = viewModel.getImage(urlString: gameImage2 ?? "")
    }
    
    func didLoadImage() {
        firstGameImg.image = viewModel.imageFromCache(identifier: gameImage0 ?? "")
        secondGameImg.image = viewModel.imageFromCache(identifier: gameImage1 ?? "")
        thirdGameImg.image = viewModel.imageFromCache(identifier: gameImage2 ?? "")
    }
}
