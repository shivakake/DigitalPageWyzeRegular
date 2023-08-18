//
//  MenuItemModel.swift
//  WenoiUI
//
//  Created by Roushil singla on 10/13/20.
//  Copyright © 2020 personal. All rights reserved.
//

import Foundation
import Cocoa

public struct PopUpMenuItemModel {
    
    public var intID: Int?
    public var strID: String?
    public var itemName: String?
    public var itemImage: String?
    
    public init() {
        strID     = ""
        itemName  = ""
        itemImage = ""
    }
    
    public init(intMenuId: Int?, menuName: String?, menuImage: String?) {
        intID = intMenuId
        itemName = menuName
        itemImage = menuImage
    }
    
    public init(strMenuID: String?, menuName: String?, menuImage: String?) {
        strID = strMenuID
        itemName = menuName
        itemImage = menuImage
    }
}
