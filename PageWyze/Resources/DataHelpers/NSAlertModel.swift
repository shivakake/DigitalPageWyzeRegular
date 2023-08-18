//
//  NSAlertModel.swift
//  WenoiUILib
//
//  Created by Roushil singla on 10/7/20.
//  Copyright © 2020 personal. All rights reserved.
//

import Foundation
import Cocoa

public struct AlertSheetModel {
    
    var title: String?
    var description: String?
    var image: NSImage?
    
    public init(title: String?, descInfo: String?, image: NSImage?) {
        self.title = title
        self.description = descInfo
        self.image = image
    }
    
    /* Prepare alert with informations and make callback for adding buttons as per requirement */
    public func handleActions(completion: ((NSAlert)-> Void)?) {
        
        let alert = NSAlert()
        alert.messageText = title ?? ""
        alert.informativeText = description ?? ""
        alert.icon = image 
        completion?(alert)
    }
}
