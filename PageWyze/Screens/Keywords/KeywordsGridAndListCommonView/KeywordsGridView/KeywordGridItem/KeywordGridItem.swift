//
//  KeywordGridItem.swift
//  WebSites
//
//  Created by PGK Shiva Kumar on 04/01/23.
//

import Cocoa

class KeywordGridItem: NSCollectionViewItem {
    
    @IBOutlet weak var cellBackGroundView: NSView!
    @IBOutlet weak var keywordTitleLabel: NSTextField!
    @IBOutlet weak var statusImageView: NSImageView!
    @IBOutlet weak var keywordCreatedDateLabel: NSTextField!
    
    override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: "KeywordGridItem", bundle: Bundle(for: KeywordGridItem.self))
    }
    
    required init?(coder: NSCoder) {
        super.init(nibName: "KeywordGridItem", bundle: Bundle(for: KeywordGridItem.self))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCell()
    }
    
    fileprivate func setupCell() {
        cellBackGroundView.wantsLayer = true
        cellBackGroundView.addShadow(color: .darkGray)
        cellBackGroundView.layer?.cornerRadius = 5
        statusImageView.wantsLayer = true
        statusImageView.layer?.cornerRadius = statusImageView.frame.size.height / 2
        keywordTitleLabel.font = .styleSelectionForTitle
        keywordCreatedDateLabel.font = .styleSelectionMeta
    }
    
    public func configureCell(keywordModel: KeywordDetailsDataModel?) {
        keywordTitleLabel.stringValue = keywordModel?.name ?? ""
        keywordCreatedDateLabel.stringValue = keywordModel?.updated ?? ""
        statusImageView.setStatusImage(status: keywordModel?.datastatus ?? "")
    }
}
