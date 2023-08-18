//
//  BandMenuItemCell.swift
//  WenoiUI
//
//  Created by Roushil singla on 9/1/20.
//  Copyright © 2020 personal. All rights reserved.
//

import Cocoa

public class PopUpMenuItemCell: NSTableCellView {
    
    @IBOutlet weak var menuImage: NSImageView!
    @IBOutlet weak var menuLabel: NSTextField!
    
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageWidthConstraint: NSLayoutConstraint!
    
    
    /* Setting up Values for each items in cell.
     If badge is initilaized then only badge will be visible */
    public var setUpValueForItems: PopUpMenuItemModel? {
        didSet {
            
            let imageName = setUpValueForItems?.itemImage ?? ""
            
            if imageName.isEmpty {
                menuImage.isHidden = true
            } else {
                menuImage.isHidden = false
                menuImage.image = NSImage(named: setUpValueForItems?.itemImage ?? "")
                menuImage.contentTintColor = StyleSheet.appColor
            }
            menuLabel.stringValue = setUpValueForItems?.itemName ?? ""
        }
    }
    
    /// Constraint for image only in item
    public var applyConstraintForImage: Int? {
        didSet {
            imageWidthConstraint.constant   = CGFloat(applyConstraintForImage ?? 15)
            imageHeightConstraint.constant  = CGFloat(applyConstraintForImage ?? 15)
        }
    }
    
    
    /* Draw layers and boundaries for message */
    public override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
    }
    
}

