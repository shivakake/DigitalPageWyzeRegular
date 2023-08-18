//
//  PageDataDeleteCustomCell.swift
//  PageWyze
//
//  Created by PGK Shiva Kumar on 03/02/23.
//

import Cocoa

class PageDataDeleteCustomCell: NSTableCellView {
    
    public var deletePageCallBack: (() -> Void)?
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    @IBAction func deletePageTapped(_ sender: NSButton) {
        deletePageCallBack?()
    }
}
