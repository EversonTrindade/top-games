//
//  DetailViewModel.swift
//  Top Games
//
//  Created by Everson Trindade on 11/05/18.
//  Copyright © 2018 Everson Trindade. All rights reserved.
//

import Foundation
import UIKit

struct GameDetailDTO {
    var name = ""
    var large = ""
    var viewers = 0
    
}

protocol DetailGameLoadContent: class {
    func didLoadImage()
}

protocol DetailGameViewModelPresentable: class {
    func getImage() -> UIImage?
    func imageFromCache() -> UIImage?
    func favoriteGame() -> Bool
}

class DetailGameViewModel: DetailGameViewModelPresentable {
    
    // MARK: Propertiers
    private var imageId = ""
    weak var loadContentDelegate: DetailGameLoadContent?
    private var cache = NSCache<NSString, UIImage>()
    
    // MARK: Init
    init(delegate: DetailGameLoadContent, imageId: String) {
        loadContentDelegate = delegate
        self.imageId = imageId
    }
    
    // MARK: - CachedImageLoadContent
    func getImage() -> UIImage? {
        if let imageCached = cache.object(forKey: NSString(string: imageId)) {
            return imageCached
        }
        
        let placeholder = UIImage(named: "icon-placeholder")
        placeholder?.accessibilityIdentifier = "placeholder"
        cache.setObject(placeholder ?? UIImage(), forKey: NSString(string: imageId))
        
        if let url = URL(string: imageId) {
            URLSession.shared.dataTask(with: url, completionHandler: { data, _, _ in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.cache.setObject(image, forKey: NSString(string: self.imageId))
                        self.loadContentDelegate?.didLoadImage()
                    }
                }
            }).resume()
        }
        return nil
    }
    
    func imageFromCache() -> UIImage? {
        return cache.object(forKey: NSString(string: imageId))
    }
    
    // MARK: Functions
    func favoriteGame() -> Bool {
        return true
    }
}
