//
//  AlertMethodClass.swift
//  Oasis
//
//  Created by Nikhil Narayan on 13/08/21.
//

import Foundation
import Cocoa

public class AlertMethodClass {
    
    public init() {}
    
    let loaderViewObj = AlertView()
    
    public func showLoader(view: NSView, showSpinner: Bool) {
        view.addSubview(loaderViewObj)
        loaderViewObj.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loaderViewObj.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            loaderViewObj.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            loaderViewObj.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            loaderViewObj.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: 0)
        ])
        loaderViewObj.wantsLayer = true
        loaderViewObj.layer?.cornerRadius = 5
        loaderViewObj.lowAlphaView.isUserInteractionEnabled = false
        if showSpinner {
            loaderViewObj.spinnerIndicator.startAnimation(nil)
        } else {
            loaderViewObj.spinnerIndicator.stopAnimation(nil)
        }

    }
    
    
    public func removeLoader() {
        DispatchQueue.main.async {
            self.loaderViewObj.spinnerIndicator.stopAnimation(nil)
            self.loaderViewObj.removeFromSuperview()
        }
    }
    
}
