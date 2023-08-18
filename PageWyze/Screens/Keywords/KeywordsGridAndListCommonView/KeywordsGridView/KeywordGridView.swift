//
//  KeywordGridView.swift
//  WebSites
//
//  Created by PGK Shiva Kumar on 04/01/23.
//

import Cocoa

class KeywordGridView: NSView {
    
    @IBOutlet var parentCustomView: NSView!
    @IBOutlet weak var keywordsGridColletionView: NSCollectionView!
    
    @IBOutlet weak var noDataField: NSTextField!
    public var keywordLogic: KeywordLogic?
    public var onGridItemSelection: ((Int) -> Void)?
    
    init(keywordLogic: KeywordLogic) {
        super.init(frame: .zero)
        self.keywordLogic = keywordLogic
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
        Bundle(for: KeywordGridView.self).loadNibNamed("KeywordGridView", owner: self, topLevelObjects: nil)
        let contentFrame = NSMakeRect(0, 0, frame.size.width, frame.size.height)
        parentCustomView.frame = contentFrame
        addSubview(parentCustomView)
    }
    
    public func configureColletionView() {
        keywordsGridColletionView.dataSource = self
        keywordsGridColletionView.delegate = self
    }
    
    public func reloadData() {
        noDataField.isHidden = keywordLogic?.sortedKeywordListArray.isEmpty == false
        keywordsGridColletionView.reloadData()
    }
    
    public func reloadSelectedKeyword(index: Int) {
        keywordsGridColletionView.reloadItems(at: [IndexPath(item: index, section: 0)])
    }
    
    public func removeSelectedKeyword(index: Int) {
        keywordsGridColletionView.deleteItems(at: [IndexPath(item: index, section: 0)])
        noDataField.isHidden = keywordLogic?.sortedKeywordListArray.isEmpty == false
    }
    
    public func addKeyword() {
        noDataField.isHidden = true
        let indexPath = IndexPath(item: 0, section: 0)
        keywordsGridColletionView.insertItems(at: [indexPath])
    }
}

extension KeywordGridView : NSCollectionViewDataSource {
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return keywordLogic?.sortedKeywordListArray.count ?? 0
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        if let cell = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "KeywordGridItem"), for: indexPath) as? KeywordGridItem {
            cell.configureCell(keywordModel: keywordLogic?.sortedKeywordListArray[indexPath.item])
            return cell
        }
        return NSCollectionViewItem()
    }
}

extension KeywordGridView : NSCollectionViewDelegate {
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        guard let indexPath = indexPaths.first?.item else { return }
        if indexPath != -1 {
            onGridItemSelection?(indexPath)
        }
        collectionView.deselectItems(at: indexPaths)
    }
}
