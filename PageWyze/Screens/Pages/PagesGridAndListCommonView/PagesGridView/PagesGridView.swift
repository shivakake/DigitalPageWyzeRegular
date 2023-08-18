//
//  PagesGridView.swift
//  WebSites
//
//  Created by PGK Shiva Kumar on 30/12/22.
//

import Cocoa

class PagesGridView: NSView {
    
    @IBOutlet var parentCustomView: NSView!
    @IBOutlet weak var pagesGridCollectionView: NSCollectionView!
    @IBOutlet weak var noDataField: NSTextField!
    
    public var pageLogic: PagesLogic?
    public var onGridItemSelection: ((Int) -> Void)?
    public var pageURL = ""
    
    init(pageLogic: PagesLogic) {
        super.init(frame: .zero)
        self.pageLogic = pageLogic
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
        Bundle(for: PagesGridView.self).loadNibNamed("PagesGridView", owner: self, topLevelObjects: nil)
        let contentFrame = NSMakeRect(0, 0, frame.size.width, frame.size.height)
        parentCustomView.frame = contentFrame
        addSubview(parentCustomView)
    }
    
    public func configureColletionView() {
        pagesGridCollectionView.dataSource = self
        pagesGridCollectionView.delegate = self
    }
    
    public func reloadData() {
        noDataField.isHidden = pageLogic?.sortedPageListArray.isEmpty == false
        pagesGridCollectionView.reloadData()
    }
    
    public func reloadSelectedPage(index: Int) {
        pagesGridCollectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
    }
    
    public func removeSelectedPage(index: Int) {
        pagesGridCollectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
        noDataField.isHidden = pageLogic?.sortedPageListArray.isEmpty == false
    }
    
    public func addPage() {
        noDataField.isHidden = true
        let indexPath = IndexPath(item: 0, section: 0)
        pagesGridCollectionView.insertItems(at: [indexPath])
    }
}

extension PagesGridView : NSCollectionViewDataSource {
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return pageLogic?.sortedPageListArray.count ?? 0
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        if let cell = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "PagesGridItem"), for: indexPath) as? PagesGridItem {
            cell.configureCell(pageModel: pageLogic?.sortedPageListArray[indexPath.item])
            cell.pageLinkCallBack = { [weak self] pageLink in
                guard let _self = self else { return }
                _self.pageURL = pageLink
            }
            return cell
        }
        return NSCollectionViewItem()
    }
}

extension PagesGridView : NSCollectionViewDelegate {
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        guard let indexPath = indexPaths.first?.item else { return }
        if indexPath != -1 {
            onGridItemSelection?(indexPath)
        }
        collectionView.deselectItems(at: indexPaths)
    }
}
