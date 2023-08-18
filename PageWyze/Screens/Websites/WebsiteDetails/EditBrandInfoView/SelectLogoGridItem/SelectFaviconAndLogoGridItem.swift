//
//  SelectFaviconAndLogoGridItem.swift
//  PageWyze
//
//  Created by PGK Shiva Kumar on 09/02/23.
//

import Cocoa

class SelectFaviconAndLogoGridItem: NSCollectionViewItem {
    
    @IBOutlet weak var backGroundView: NSView!
    @IBOutlet weak var logoImageView: NSImageView!
    @IBOutlet weak var logoNameLabel: NSTextField!
    
    public var websiteImageUrl = ""
    public var directoriesString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCell()
    }
    
    override func viewWillLayout() {
        super.viewWillLayout()
    }
    
    override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: "SelectFaviconAndLogoGridItem", bundle: Bundle(for: SelectFaviconAndLogoGridItem.self))
    }
    
    required init?(coder: NSCoder) {
        super.init(nibName: "SelectFaviconAndLogoGridItem", bundle: Bundle(for: SelectFaviconAndLogoGridItem.self))
    }
    
    public func setupCell() {
        backGroundView.addShadow(color: .lightGray)
        backGroundView.layer?.cornerRadius = 10
    }
    
    public func configureCell(nameString: String? , imageString: String?) {
        logoNameLabel.stringValue = nameString ?? ""
        if let image = imageString {
            let finalImage = websiteImageUrl + directoriesString + "/\(image)"
            logoImageView.getImageFormURLString(imageString: finalImage)
        }
    }
}
