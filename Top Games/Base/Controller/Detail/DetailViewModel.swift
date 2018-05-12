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
    var image = ""
    var views = 0
}

protocol DetailGameLoadContent: class {
    func didLoadImage()
}

protocol DetailGameViewModelPresentable: class {
    func getImage() -> UIImage?
    func imageFromCache() -> UIImage?
}

class DetailGameViewModel: DetailGameViewModelPresentable {
    
    private var imageId = ""
    weak var loadContentDelegate: DetailGameLoadContent?
    private var cache = NSCache<NSString, UIImage>()
    
    init(delegate: DetailGameLoadContent, imageId: String) {
        loadContentDelegate = delegate
        self.imageId = imageId
    }
    
    // MARK: - CachedImageLoadContent
//    func didLoadImage(identifier: String) {
//        loadContentDelegate?.didLoadImage()
//    }
    
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
}
