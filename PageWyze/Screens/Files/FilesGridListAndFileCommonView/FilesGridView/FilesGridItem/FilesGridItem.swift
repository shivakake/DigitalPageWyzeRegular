//
//  FilesGridItem.swift
//  WebSites
//
//  Created by PGK Shiva Kumar on 04/01/23.
//

import Cocoa

class FilesGridItem: NSCollectionViewItem {
    
    @IBOutlet weak var cellBackGroundView: NSView!
    @IBOutlet weak var fileNameLabel: NSTextField!
    @IBOutlet weak var fileLinkLabel: NSTextField!
    @IBOutlet weak var fileCreatedDateLabel: NSTextField!
    @IBOutlet weak var statusImageView: NSImageView!
    @IBOutlet weak var fileLogoImageView: NSImageView!
    
    var fileLinkCallBack: ((String) -> Void)?
    
    override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: "FilesGridItem", bundle: Bundle(for: FilesGridItem.self))
    }
    
    required init?(coder: NSCoder) {
        super.init(nibName: "FilesGridItem", bundle: Bundle(for: FilesGridItem.self))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCell()
    }
    
    @objc func fileLinkTapped() {
        fileLinkCallBack?(fileLinkLabel.stringValue)
    }
    
    public func setupCell() {
        cellBackGroundView.wantsLayer = true
        cellBackGroundView.addShadow(color: .darkGray)
        cellBackGroundView.layer?.cornerRadius = 5
        statusImageView.wantsLayer = true
        statusImageView.layer?.cornerRadius = statusImageView.frame.size.height / 2
        fileLogoImageView.wantsLayer = true
        fileLogoImageView.layer?.cornerRadius = 5
        fileNameLabel.font = .styleSelectionForLargeTitle
        fileLinkLabel.font = .styleSelectionMeta
        fileLinkLabel.textColor = .systemBlue
        fileCreatedDateLabel.font = .styleSelectionMeta
        fileLinkLabel.addGestureRecognizer(NSClickGestureRecognizer(target: self, action: #selector(fileLinkTapped)))
    }
    
    public func configureCell(fileModel: WebsiteDetailsDataModel?) {
        fileNameLabel.stringValue = fileModel?.name ?? ""
        fileLinkLabel.stringValue = fileModel?.url ?? ""
        fileCreatedDateLabel.stringValue = fileModel?.updated ?? ""
        fileLogoImageView.image = NSImage(named: fileModel?.logourl ?? "")
        statusImageView.image = NSImage(named: fileModel?.datastatus ?? "live")
    }
}
