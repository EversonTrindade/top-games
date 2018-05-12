//
//  TodayViewModel.swift
//  GamesWidget
//
//  Created by Everson Trindade on 12/05/18.
//  Copyright © 2018 Everson Trindade. All rights reserved.
//

import Foundation
import UIKit

protocol TodayLoadContent: class {
    func didLoadImage()
}

protocol TodayViewModelPresentable: class {
    func getImage(urlString: String) -> UIImage?
    func imageFromCache(identifier: String) -> UIImage?
}

class TodayViewModel: TodayViewModelPresentable {
    
    weak var loadContentDelegate: TodayLoadContent?
    private var cache = NSCache<NSString, UIImage>()
    
    init(delegate: TodayLoadContent?) {
        loadContentDelegate = delegate
    }
    
    func getImage(urlString: String) -> UIImage? {
        
        let placeholder = UIImage(named: "icon-placeholder")
        placeholder?.accessibilityIdentifier = "placeholder"
        
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url, completionHandler: { data, _, _ in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.cache.setObject(image, forKey: NSString(string: urlString))
                        self.loadContentDelegate?.didLoadImage()
                    }
                }
            }).resume()
        }
        return UIImage()
    }
    
    func imageFromCache(identifier: String) -> UIImage? {
        return cache.object(forKey: NSString(string: identifier))
    }
}
