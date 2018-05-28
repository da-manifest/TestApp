//
//  ActivityIndicator.swift
//  TestApp
//
//  Created by Admin on 26.05.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

private struct Constants {
    
    static let activityIndicatorSize: CGFloat = 40
    static let overlayAlpha: CGFloat = 0.5
    static let overlayColor = UIColor.black.withAlphaComponent(Constants.overlayAlpha)
}

final class ActivityIndicator {
    
    static let shared = ActivityIndicator()
    
    var overlayView = UIView()
    var activityIndicator = UIActivityIndicatorView()
    
    func show(on view: UIView) {
        overlayView.frame = view.frame
        overlayView.center = view.center
        overlayView.backgroundColor = Constants.overlayColor
        overlayView.clipsToBounds = true
        
        activityIndicator.frame = CGRect(x: 0, y: 0,
                                         width: Constants.activityIndicatorSize,
                                         height: Constants.activityIndicatorSize)
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        activityIndicator.color = .black
        activityIndicator.center = CGPoint(x: overlayView.bounds.width / 2,
                                           y: overlayView.bounds.height / 2)
        
        overlayView.addSubview(activityIndicator)
        
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            view.addSubview(self.overlayView)
            self.activityIndicator.startAnimating()
        }
    }
    
    func hide() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.stopAnimating()
            self?.overlayView.removeFromSuperview()
        }
    }
}
