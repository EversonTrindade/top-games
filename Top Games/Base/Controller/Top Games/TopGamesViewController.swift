//
//  TopGamesViewController.swift
//  Top Games
//
//  Created by Everson Trindade on 08/05/18.
//  Copyright © 2018 Everson Trindade. All rights reserved.
//

import UIKit

fileprivate struct CellIdentifier {
    static let gameIdentifier = "TopGamesViewCell"
}

class TopGamesViewController: UIViewController, LoadContent {

    // MARK: Properties
    lazy var viewModel: TopGamesViewModelPresentable = TopGamesViewModel(delegate: self)
    let refresher = UIRefreshControl()

    // MARK: IBOutlet
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: ViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadContent()
        addRefresh()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let detailViewcontroller = segue.destination as? DetailViewController, let dto = sender as? GameDetailDTO {
                detailViewcontroller.fill(with: dto)
            }
        }
    }
    
    func checkConnectionAndGetGames() {
        if Reachability.isConnectedToNetwork() {
            showLoader()
            viewModel.getGames()
        } else {
            showDefaultAlert(message: "No connetion!", completeBlock: nil)
            dismissLoader()
        }
    }
    
    // MARK: - Private methods
    private func addRefresh() {
        collectionView?.alwaysBounceVertical = true
        refresher.tintColor = .white
        refresher.addTarget(self, action: #selector(refresh), for: .valueChanged)
        collectionView?.addSubview(refresher)
    }
    
    @objc func refresh() {
        if Reachability.isConnectedToNetwork() {
            viewModel.refresh()
        } else {
            showDefaultAlert(message: "No connetion!", completeBlock: nil)
            DispatchQueue.main.async {
                self.refresher.endRefreshing()
                self.collectionView?.reloadData()
            }
        }
    }
    
    // MARK: LoadContent
    func loadContent() {
        checkConnectionAndGetGames()
    }
    
    func didLoadContent(error: String?) {
        dismissLoader()
        if let _ = error {
            showDefaultAlert(message: "Can not load movies. Try later", completeBlock: nil)
        } else {
            DispatchQueue.main.async {
                self.refresher.endRefreshing()
                self.collectionView?.reloadData()
            }
        }
    }
    
    func didLoadImage(identifier: String) {
        DispatchQueue.main.async {
            guard let collection = self.collectionView else {
                return
            }
            for cell in collection.visibleCells {
                if let gameCell = cell as? TopGamesViewCell, gameCell.identifier == identifier {
                    gameCell.setImage(with: self.viewModel.imageFromCache(identifier: identifier))
                }
            }
        }
    }
    
    func didTapOnSearchToReload() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

// MARK: UITableViewDelegate/DataSource
extension TopGamesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.gameIdentifier, for: indexPath) as? TopGamesViewCell else {
            return UICollectionViewCell()
        }
        cell.fillCell(dto: viewModel.gameDTO(row: indexPath.row))
        if indexPath.row == viewModel.numberOfItemsInSection() - 1 && viewModel.canLoad {
            checkConnectionAndGetGames()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let gameCell = cell as? TopGamesViewCell {
            gameCell.fillCell(dto: viewModel.gameDTO(row: indexPath.row))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: viewModel.getGameDetailDTO(row: indexPath.row))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return viewModel.sizeForItems(with: view.frame.size.width, height: view.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return viewModel.minimumInteritemSpacingForSectionAt()
    }
}

// MARK: Search Bar
extension TopGamesViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.updateSearchResults(for: searchController)
    }
}
