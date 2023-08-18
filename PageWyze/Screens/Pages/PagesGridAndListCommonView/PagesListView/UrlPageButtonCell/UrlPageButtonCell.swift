//
//  UrlPageButtonCell.swift
//  WebSites
//
//  Created by PGK Shiva Kumar on 09/01/23.
//

import Cocoa

class UrlPageButtonCell: NSTableCellView {
    
    @IBOutlet weak var urlLabel: NSTextField!
    
    public var urlCallBack: ((String) -> Void)?
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    @IBAction func urlPageButtonTapped(_ sender: NSButton) {
        urlCallBack?(urlLabel.stringValue)
    }
}
