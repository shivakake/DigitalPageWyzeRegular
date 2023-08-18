//
//  DetailsPageButtonCell.swift
//  WebSites
//
//  Created by PGK Shiva Kumar on 09/01/23.
//

import Cocoa

class DetailsPageButtonCell: NSTableCellView {
    
    public var detailsCallBack: (() -> Void)?
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    @IBAction func detailsPageButtonTapped(_ sender: NSButton) {
        detailsCallBack?()
    }
}
