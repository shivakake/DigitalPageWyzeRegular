//
//  WebSitesGridView.swift
//  WebSites
//
//  Created by PGK Shiva Kumar on 21/12/22.
//

import Cocoa

class WebSitesGridView: NSView {
    
    @IBOutlet var parentCustomView: NSView!
    @IBOutlet weak var websitesGridCollectionView: NSCollectionView!
    @IBOutlet weak var noDataField: NSTextField!
    
    public var websiteLogic: WebsitesLogic?
    public var onItemClick: ((Int) -> Void)?
    
    init(websiteLogic: WebsitesLogic?) {
        super.init(frame: .zero)
        self.websiteLogic = websiteLogic
        commonMethods()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonMethods()
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    public func commonMethods() {
        addView()
        configureColletionView()
    }
    
    fileprivate func addView() {
        Bundle(for: WebSitesGridView.self).loadNibNamed("WebSitesGridView", owner: self, topLevelObjects: nil)
        let contentFrame = NSMakeRect(0, 0, frame.size.width, frame.size.height)
        parentCustomView.frame = contentFrame
        addSubview(parentCustomView)
    }
    
    public func configureColletionView() {
        websitesGridCollectionView.dataSource = self
        websitesGridCollectionView.delegate = self
    }
    
    public func reloadData() {
        noDataField.isHidden = websiteLogic?.sortedWebsiteList.isEmpty == false
        websitesGridCollectionView.reloadData()
    }
    
    public func reloadSelectedWebsite(index: Int) {
        websitesGridCollectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
    }
    
    public func removeSelectedWebsite(index: Int) {
        websitesGridCollectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
        noDataField.isHidden = websiteLogic?.sortedWebsiteList.isEmpty == false
    }
    
    public func addWebsite() {
        noDataField.isHidden = true
        let indexPath = IndexPath(item: 0, section: 0)
        websitesGridCollectionView.insertItems(at: [indexPath])
    }
}

extension WebSitesGridView : NSCollectionViewDataSource {
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return websiteLogic?.sortedWebsiteList.count ?? 0
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        if let cell = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "WebSiteGridItem"), for: indexPath) as? WebSiteGridItem {
            cell.configureCell(websiteModel: websiteLogic?.sortedWebsiteList[indexPath.item])
            cell.websiteLinkCallBack = { websiteLink in
            }
            return cell
        }
        return NSCollectionViewItem()
    }
}

extension WebSitesGridView : NSCollectionViewDelegate {
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        guard let indexPath = indexPaths.first?.item else { return }
        if indexPath != -1 {
            onItemClick?(indexPath)
        }
        collectionView.deselectItems(at: indexPaths)
    }
}
