//
//  AlertView.swift
//  adjustlogo
//
//  Created by Roushil singla on 10/8/20.
//  Copyright © 2020 personal. All rights reserved.
//

import Cocoa


class AlertView: NSView {
    
    @IBOutlet weak var customView: NSView!
    @IBOutlet weak var spinnerIndicator: NSProgressIndicator!
    @IBOutlet weak var lowAlphaView: UIUserInteractionHandler!
    
    public override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        addView()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        addView()
    }
    
    public override func layout() {
        super.layout()
        lowAlphaView.wantsLayer = true
        lowAlphaView.layer?.backgroundColor = NSColor.lightGray.withAlphaComponent(0.4).cgColor
    }
    
    private func addView() {
        Bundle(for: AlertView.self).loadNibNamed("AlertView", owner: self, topLevelObjects: nil)
        let contentFrame = NSMakeRect(0, 0, frame.size.width, frame.size.height)
        customView.frame = contentFrame
        addSubview(customView)
    }
    
}
