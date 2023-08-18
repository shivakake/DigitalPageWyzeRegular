//
//  ResponsesGridItem.swift
//  WebSites
//
//  Created by PGK Shiva Kumar on 04/01/23.
//

import Cocoa

class ResponsesGridItem: NSCollectionViewItem {
    
    @IBOutlet weak var cellBackGroundView: NSView!
    @IBOutlet weak var responsesTitleLabel: NSTextField!
    @IBOutlet weak var responsesTypeLabel: NSTextField!
    @IBOutlet weak var responsesEmailLabel: NSTextField!
    @IBOutlet weak var responsesMobileLabel: NSTextField!
    @IBOutlet weak var statusImageView: NSImageView!
    @IBOutlet weak var responsesCreatedDateLabel: NSTextField!
    @IBOutlet weak var responseLogoImageView: NSImageView!
    
    override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: "ResponsesGridItem", bundle: Bundle(for: ResponsesGridItem.self))
    }
    
    required init?(coder: NSCoder) {
        super.init(nibName: "ResponsesGridItem", bundle: Bundle(for: ResponsesGridItem.self))
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
        responsesTitleLabel.font = .styleSelectionForTitle
        responsesCreatedDateLabel.font = .styleSelectionMeta
        responseLogoImageView.wantsLayer = true
        responseLogoImageView.layer?.cornerRadius = 5
        responsesTitleLabel.font = .styleSelectionForLargeTitle
        responsesTypeLabel.font = .styleSelectionForSubtitle
        responsesEmailLabel.font = .styleSelectionForSubtitle
        responsesMobileLabel.font = .styleSelectionMeta
        responsesCreatedDateLabel.font = .styleSelectionMeta
    }
    
    public func configureCell(responsesModel: WebsiteDetailsDataModel?) {
        responsesTitleLabel.stringValue = responsesModel?.name ?? ""
        responsesTypeLabel.stringValue = responsesModel?.type ?? ""
        responsesEmailLabel.stringValue = responsesModel?.categoryname ?? ""
        responsesMobileLabel.stringValue = responsesModel?.name ?? ""
        responsesCreatedDateLabel.stringValue = responsesModel?.updated ?? ""
        statusImageView.image = NSImage(named: responsesModel?.datastatus ?? "")
        responseLogoImageView.image = NSImage(named: responsesModel?.logourl ?? "")
        
    }
}
