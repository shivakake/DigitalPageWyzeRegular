//
//  TeamsGridItem.swift
//  WebSites
//
//  Created by PGK Shiva Kumar on 30/12/22.
//

import Cocoa

class TeamsGridItem: NSCollectionViewItem {
    
    @IBOutlet weak var cellBackGroundView: NSView!
    @IBOutlet weak var teamProfileImageView: NSImageView!
    @IBOutlet weak var teamTitleLabel: NSTextField!
    @IBOutlet weak var teamStatusImageView: NSImageView!
    @IBOutlet weak var teamTypeLabel: NSTextField!
    
    override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: "TeamsGridItem", bundle: Bundle(for: TeamsGridItem.self))
    }
    
    required init?(coder: NSCoder) {
        super.init(nibName: "TeamsGridItem", bundle: Bundle(for: TeamsGridItem.self))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCell()
    }
    
    public func setupCell() {
        cellBackGroundView.wantsLayer = true
        cellBackGroundView.addShadow(color: .darkGray)
        cellBackGroundView.layer?.cornerRadius = 5
        teamProfileImageView.wantsLayer = true
        teamProfileImageView.layer?.cornerRadius = teamProfileImageView.frame.size.height / 2
        teamTitleLabel.font = .styleSelectionForTitle
        teamStatusImageView.wantsLayer = true
        teamStatusImageView.layer?.cornerRadius = teamStatusImageView.frame.size.height / 2
        teamTypeLabel.font = .styleSelectionMeta
        teamProfileImageView.wantsLayer = true
        teamProfileImageView.layer?.cornerRadius = 10
    }
    
    public func configureCell(teamModel: TeamDetailsDataModel?) {
        teamTitleLabel.stringValue = teamModel?.name ?? ""
        teamTypeLabel.stringValue = teamModel?.role ?? ""
//        teamProfileImageView.image = NSImage(named: teamModel?.name2 ?? "")
        teamStatusImageView.setStatusImage(status: teamModel?.datastatus ?? "live")
    }
}
