//
//  UIViewController+eExtension.swift
//  Top Games
//
//  Created by Everson Trindade on 09/05/18.
//  Copyright © 2018 Everson Trindade. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showLoader() {
        DispatchQueue.main.async {
            let loader = UIActivityIndicatorView(activityIndicatorStyle: .white)
            loader.center = UIApplication.shared.keyWindow?.center ?? CGPoint()
            loader.startAnimating()
            loader.color = UIColor.black
            UIApplication.shared.keyWindow?.addSubview(loader)
        }
    }
    
    func dismissLoader() {
        DispatchQueue.main.async {
            if let loader = UIApplication.shared.keyWindow?.subviews.filter({ $0 is UIActivityIndicatorView }).first as? UIActivityIndicatorView {
                loader.removeFromSuperview()
            }
        }
    }
    
    func showDefaultAlert(message: String, completeBlock: ((UIAlertAction) -> Void)?) {
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: completeBlock)
        alertController.addAction(action)
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
