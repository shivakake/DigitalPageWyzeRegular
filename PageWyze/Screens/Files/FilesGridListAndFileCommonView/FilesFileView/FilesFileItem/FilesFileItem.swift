//
//  FilesFileItem.swift
//  WebSites
//
//  Created by PGK Shiva Kumar on 04/01/23.
//

import Cocoa

class FilesFileItem: NSCollectionViewItem {
    
    @IBOutlet weak var cellBackGroundView: NSView!
    @IBOutlet weak var fileProfileImageView: NSImageView!
    @IBOutlet weak var fileStatusImageView: NSImageView!
    @IBOutlet weak var fileNameLabel: NSTextField!
    @IBOutlet weak var fileSizeLabel: NSTextField!
    
    override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: "FilesFileItem", bundle: Bundle(for: FilesFileItem.self))
    }
    
    required init?(coder: NSCoder) {
        super.init(nibName: "FilesFileItem", bundle: Bundle(for: FilesFileItem.self))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCell()
    }
    
    public func setupCell() {
        cellBackGroundView.wantsLayer = true
        cellBackGroundView.addShadow(color: .darkGray)
        cellBackGroundView.layer?.cornerRadius = 5
        fileStatusImageView.wantsLayer = true
        fileStatusImageView.layer?.cornerRadius = fileStatusImageView.frame.size.height / 2
        fileProfileImageView.wantsLayer = true
        fileProfileImageView.layer?.cornerRadius = fileProfileImageView.frame.size.height / 2
        fileNameLabel.font = .styleSelectionForTitle
        fileSizeLabel.font = .styleSelectionMeta
    }
    
    public func configureCell(fileModel: WebsiteDetailsDataModel?) {
        fileNameLabel.stringValue = fileModel?.name ?? ""
        fileSizeLabel.stringValue = fileModel?.faviconurl ?? ""
        fileProfileImageView.image = NSImage(named: fileModel?.logourl ?? "")
        fileStatusImageView.image = NSImage(named: fileModel?.datastatus ?? "")
    }
}
