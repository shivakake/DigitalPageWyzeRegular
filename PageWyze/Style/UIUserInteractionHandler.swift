//
//  UIUserInteractionHandler.swift
//  WebSites
//
//  Created by PGK Shiva Kumar on 13/01/23.
//

import Foundation
import Cocoa

public class UIUserInteractionHandler: NSView {
    
    public var isUserInteractionEnabled = true
    
    public override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    /* Set User Interaction for View */
    public override func hitTest(_ point: NSPoint) -> NSView? {
        return self.isUserInteractionEnabled ? super.hitTest(point) : nil
    }
}
