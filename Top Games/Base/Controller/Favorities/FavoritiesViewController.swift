//
//  FavoritiesViewController.swift
//  Top Games
//
//  Created by Everson Trindade on 08/05/18.
//  Copyright © 2018 Everson Trindade. All rights reserved.
//

import UIKit

fileprivate struct CellIdentifier {
    static let favorite = "FavoriteViewCell"
    static let none = "NoOneFavoritedViewCell"
}

class FavoritiesViewController: UIViewController, FavoritiesLoadContent {

    // MARK: Properties
    private lazy var viewModel: FavoritiesViewModelPresentable = FavoritiesViewModel(delegate: self)
    
    // MARK: IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: ViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getFavoritiesGames()
    }
    
    // MARK: Functions
    func setLayout() {
        tableView.tableFooterView = UIView()
    }
    
    func getFavoritiesGames() {
        showLoader()
        viewModel.getFavoritiesGames()
    }
    
    func didLoadContent(gamesCount: Int) {
        dismissLoader()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

// MARK: UITableViewDelegate/UITableViewDataSource
extension FavoritiesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewModel.numberOfGames() == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.none, for: indexPath) as? NoOneFavoritedViewCell else {
                return UITableViewCell()
            }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.favorite, for: indexPath) as? FavoriteViewCell else {
                return UITableViewCell()
            }
            cell.fillCell(dto: viewModel.getFavorite(index: indexPath.row))
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.heightForRow()
    }
}
