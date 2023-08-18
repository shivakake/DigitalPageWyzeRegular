//
//  TabGridItem.swift
//  WebSites
//
//  Created by Nagendar on 21/12/22.
//

import Cocoa

class TabGridItem: NSCollectionViewItem {
    
    @IBOutlet weak var backGroundView: NSView!
    @IBOutlet weak var nameLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCell()
    }
    
    override func viewWillLayout() {
        super.viewWillLayout()
    }
    
    override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: "TabGridItem", bundle: Bundle(for: TabGridItem.self))
    }
    
    required init?(coder: NSCoder) {
        super.init(nibName: "TabGridItem", bundle: Bundle(for: TabGridItem.self))
    }
    
    public func setupCell() {
        backGroundView.addShadow(color: .lightGray)
        backGroundView.layer?.cornerRadius = 5
        backGroundView.wantsLayer = true
        backGroundView.layer?.backgroundColor = NSColor.gray.cgColor
    }
}
