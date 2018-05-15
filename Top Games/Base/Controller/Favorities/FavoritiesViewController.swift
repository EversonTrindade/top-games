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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setLayout()
        getFavoritiesGames()
    }
    
    // MARK: Functions
    func setLayout() {
        tableView.tableFooterView = UIView()
        tabBarController?.navigationItem.title = "Favorites"
    }
    
    func getFavoritiesGames() {
        showLoader()
        viewModel.getFavoritiesGames()
    }
    
    func didLoadContent() {
        dismissLoader()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // MARK: Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let detailViewcontroller = segue.destination as? DetailViewController, let dto = sender as? GameDetailDTO {
                detailViewcontroller.fill(with: dto)
            }
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
        performSegue(withIdentifier: "showDetail", sender: viewModel.getGameDetailDTO(row: indexPath.row))
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.heightForRow()
    }
}
