//
//  RoleGridItem.swift
//  WebSites
//
//  Created by PGK Shiva Kumar on 31/12/22.
//

import Cocoa

class RoleGridItem: NSCollectionViewItem {
    
    @IBOutlet weak var cellBackGroundView: NSView!
    @IBOutlet weak var roleNameLabel: NSTextField!
    @IBOutlet weak var roleDescriptionLabel: NSTextField!
    @IBOutlet weak var roleCreatedDateLabel: NSTextField!
    @IBOutlet weak var statusImageView: NSImageView!
    
    override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: "RoleGridItem", bundle: Bundle(for: RoleGridItem.self))
    }
    
    required init?(coder: NSCoder) {
        super.init(nibName: "RoleGridItem", bundle: Bundle(for: RoleGridItem.self))
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
        roleNameLabel.font = .styleSelectionForLargeTitle
        roleDescriptionLabel.font = .styleSelectionForSubtitle
        roleCreatedDateLabel.font = .styleSelectionMeta
    }
    
    public func configureCell(roleModel: RoleDataModel?) {
        roleNameLabel.stringValue = roleModel?.name ?? ""
        roleDescriptionLabel.stringValue = roleModel?.description ?? ""
        roleCreatedDateLabel.stringValue = roleModel?.id ?? ""
        statusImageView.setStatusImage(status: roleModel?.datastatus ?? "live")
    }
}
