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

class TopGamesViewController: UICollectionViewController, LoadContent {
    
    // MARK: Properties
    lazy var viewModel: TopGamesViewModelPresentable = TopGamesViewModel(delegate: self)
    
    // MARK: ViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadContent()
    }
    
    // MARK: LoadContent
    func loadContent() {
        showLoader()
        viewModel.getGames()
    }
    
    func didLoadContent(error: String?) {
        dismissLoader()
        if let _ = error {
            
        } else {
            DispatchQueue.main.async {
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
}

// MARK: UITableViewDelegate/DataSource
extension TopGamesViewController: UICollectionViewDelegateFlowLayout{
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.numberOfSections()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.gameIdentifier, for: indexPath) as? TopGamesViewCell else {
            return UICollectionViewCell()
        }
        cell.fillCell(dto: viewModel.gameDTO(row: indexPath.row))
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let gameCell = cell as? TopGamesViewCell {
            gameCell.fillCell(dto: viewModel.gameDTO(row: indexPath.row))
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return viewModel.sizeForItems(with: view.frame.size.width, height: view.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return viewModel.minimumInteritemSpacingForSectionAt()
    }
}
