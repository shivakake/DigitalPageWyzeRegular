//
//  WebSiteGridItem.swift
//  WebSites
//
//  Created by PGK Shiva Kumar on 21/12/22.
//

import Cocoa

class WebSiteGridItem: NSCollectionViewItem {
    
    @IBOutlet weak var cellBackGroundView: NSView!
    @IBOutlet weak var websiteProfileImageView: NSImageView!
    @IBOutlet weak var websiteNameLabel: NSTextField!
    @IBOutlet weak var websiteDescriptionLabel: NSTextField!
    @IBOutlet weak var websiteLinkLabel: NSTextField!
    @IBOutlet weak var websiteCreatedDateLabel: NSTextField!
    @IBOutlet weak var statusImageView: NSImageView!
    @IBOutlet weak var websiteLogoImageView: NSImageView!
    
    public var websiteLinkCallBack: ((String) -> Void)?
    
    override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: "WebSiteGridItem", bundle: Bundle(for: WebSiteGridItem.self))
    }
    
    required init?(coder: NSCoder) {
        super.init(nibName: "WebSiteGridItem", bundle: Bundle(for: WebSiteGridItem.self))
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
        websiteLogoImageView.wantsLayer = true
        websiteLogoImageView.layer?.cornerRadius = 5
        websiteNameLabel.font = .styleSelectionForSubtitle
        websiteDescriptionLabel.font = .styleSelectionForSubtitle
        websiteLinkLabel.font = .styleSelectionMeta
        websiteCreatedDateLabel.font = .styleSelectionMeta
        websiteLinkLabel.textColor = .systemBlue
        websiteLinkLabel.addGestureRecognizer(NSClickGestureRecognizer(target: self, action: #selector(websiteLinkTapped)))
        websiteProfileImageView.wantsLayer = true
        websiteProfileImageView.layer?.cornerRadius = 10
    }
    
    public func configureCell(websiteModel: WebsiteDetailsDataModel?) {
        websiteNameLabel.stringValue = websiteModel?.name ?? ""
        websiteDescriptionLabel.stringValue = websiteModel?.description ?? ""
        websiteLinkLabel.stringValue = websiteModel?.url ?? ""
        websiteCreatedDateLabel.stringValue = websiteModel?.updated ?? ""
        websiteLogoImageView.getImageFormURLString(imageString: websiteModel?.logourl ?? "")
        websiteProfileImageView.getImageFormURLString(imageString: websiteModel?.faviconurl ?? "")
        statusImageView.setStatusImage(status: websiteModel?.datastatus ?? "")
    }
    
    @objc func websiteLinkTapped() {
        websiteLinkCallBack?(websiteLinkLabel.stringValue)
    }
}
