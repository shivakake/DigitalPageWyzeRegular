//
//  ComponentGridItem.swift
//  WebSites
//
//  Created by PGK Shiva Kumar on 30/12/22.
//

import Cocoa

class ComponentGridItem: NSCollectionViewItem {
    
    @IBOutlet weak var cellBackGroundView: NSView!
    @IBOutlet weak var componentNameLabel: NSTextField!
    @IBOutlet weak var componentDescriptionLabel: NSTextField!
    @IBOutlet weak var componentCreatedDateLabel: NSTextField!
    @IBOutlet weak var statusImageView: NSImageView!
    @IBOutlet weak var componentLogoImageView: NSImageView!
    
    override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: "ComponentGridItem", bundle: Bundle(for: ComponentGridItem.self))
    }
    
    required init?(coder: NSCoder) {
        super.init(nibName: "ComponentGridItem", bundle: Bundle(for: ComponentGridItem.self))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCell()
    }
    
    public func setupCell() {
        cellBackGroundView.wantsLayer = true
        cellBackGroundView.addShadow(color: .darkGray)
        cellBackGroundView.layer?.cornerRadius = 5
        statusImageView.wantsLayer = true
        statusImageView.layer?.cornerRadius = statusImageView.frame.size.height / 2
        componentLogoImageView.wantsLayer = true
        componentLogoImageView.layer?.cornerRadius = 5
        componentNameLabel.font = .styleSelectionForTitle
        componentDescriptionLabel.font = .styleSelectionForSubtitle
        componentCreatedDateLabel.font = .styleSelectionMeta
    }
    
    public func configureCell(componentModel: ComponentDetailsDataModel?) {
        componentNameLabel.stringValue = componentModel?.name ?? ""
        componentDescriptionLabel.stringValue = componentModel?.description ?? ""
        componentCreatedDateLabel.stringValue = componentModel?.updated ?? ""
        //        componentLogoImageView.image = NSImage(named: componentModel?.logourl ?? "")
        statusImageView.setStatusImage(status: componentModel?.datastatus ?? "live")
    }
}
