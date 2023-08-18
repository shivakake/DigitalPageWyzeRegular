//
//  PagesGridItem.swift
//  WebSites
//
//  Created by PGK Shiva Kumar on 30/12/22.
//

import Cocoa

class PagesGridItem: NSCollectionViewItem {
    
    @IBOutlet weak var cellBackGroundView: NSView!
    @IBOutlet weak var pageNameLabel: NSTextField!
    @IBOutlet weak var pageMetaNameLabel: NSTextField!
    @IBOutlet weak var pageDescriptionLabel: NSTextField!
    @IBOutlet weak var pageLinkLabel: NSTextField!
    @IBOutlet weak var pageCreatedDateLabel: NSTextField!
    @IBOutlet weak var statusImageView: NSImageView!
    @IBOutlet weak var pageLogoImageView: NSImageView!
    
    public var pageLinkCallBack: ((String) -> Void)?
    
    override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: "PagesGridItem", bundle: Bundle(for: PagesGridItem.self))
    }
    
    required init?(coder: NSCoder) {
        super.init(nibName: "PagesGridItem", bundle: Bundle(for: PagesGridItem.self))
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
        pageLogoImageView.wantsLayer = true
        pageLogoImageView.layer?.cornerRadius = 5
        pageNameLabel.font = .styleSelectionForLargeTitle
        pageMetaNameLabel.font = .styleSelectionForSubtitle
        pageDescriptionLabel.font = .styleSelectionForSubtitle
        pageLinkLabel.font = .styleSelectionMeta
        pageCreatedDateLabel.font = .styleSelectionMeta
        pageLinkLabel.textColor = .systemBlue
        pageLinkLabel.addGestureRecognizer(NSClickGestureRecognizer(target: self, action: #selector(pageLinkLabelTapped)))
    }
    
    public func configureCell(pageModel: PageDetailsDataModel?) {
        pageNameLabel.stringValue = pageModel?.name ?? ""
        pageMetaNameLabel.stringValue = pageModel?.metatitle ?? ""
        pageDescriptionLabel.stringValue = pageModel?.description ?? ""
        pageLinkLabel.stringValue = pageModel?.url ?? ""
        pageCreatedDateLabel.stringValue = pageModel?.updated ?? ""
        statusImageView.setStatusImage(status: pageModel?.datastatus ?? "live")
        if let logoImage = pageModel?.type {
            let finalImage = logoImage + ".png"
            pageLogoImageView.getImageFormURLString(imageString: finalImage)
        }
    }
    
    @objc func pageLinkLabelTapped() {
        pageLinkCallBack?(pageLinkLabel.stringValue)
    }
}
