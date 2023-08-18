//
//  AnalyticsGridView.swift
//  WebSites
//
//  Created by PGK Shiva Kumar on 04/01/23.
//

import Cocoa

class ResponsesGridView: NSView {
    
    @IBOutlet var parentCustomView: NSView!
    @IBOutlet weak var responsesGridColletionView: NSCollectionView!
    
    var responsesListArray : [WebsiteDetailsDataModel] = [WebsiteDetailsDataModel]()
    var responsesDetailsCallBack: ((WebsiteDetailsDataModel) -> Void)?
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
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
        Bundle(for: ResponsesGridView.self).loadNibNamed("ResponsesGridView", owner: self, topLevelObjects: nil)
        let contentFrame = NSMakeRect(0, 0, frame.size.width, frame.size.height)
        parentCustomView.frame = contentFrame
        addSubview(parentCustomView)
    }
    
    public func configureColletionView() {
        responsesGridColletionView.dataSource = self
        responsesGridColletionView.delegate = self
    }
}

extension ResponsesGridView : NSCollectionViewDataSource {
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return responsesListArray.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        if let cell = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ResponsesGridItem"), for: indexPath) as? ResponsesGridItem {
            cell.configureCell(responsesModel: responsesListArray[indexPath.item])
            return cell
        }
        return NSCollectionViewItem()
    }
}

extension ResponsesGridView : NSCollectionViewDelegate {
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        guard let indexPath = indexPaths.first else { return }
        responsesDetailsCallBack?(responsesListArray[indexPath.item])
    }
}
