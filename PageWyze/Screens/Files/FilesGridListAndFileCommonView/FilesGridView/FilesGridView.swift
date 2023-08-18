//
//  FilesGridView.swift
//  WebSites
//
//  Created by PGK Shiva Kumar on 04/01/23.
//

import Cocoa

class FilesGridView: NSView {
    
    @IBOutlet var parentCustomView: NSView!
    @IBOutlet weak var filesGridColletionView: NSCollectionView!
    
    var filesListArray : [WebsiteDetailsDataModel] = [WebsiteDetailsDataModel]()
    var url = ""
    
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
        getFilesList()
        configureColletionView()
    }
    
    fileprivate func addView() {
        Bundle(for: FilesGridView.self).loadNibNamed("FilesGridView", owner: self, topLevelObjects: nil)
        let contentFrame = NSMakeRect(0, 0, frame.size.width, frame.size.height)
        parentCustomView.frame = contentFrame
        addSubview(parentCustomView)
    }
    
    public func getFilesList() {
//        filesListArray = gridViewRef.websitesListArray
    }
    
    public func configureColletionView() {
        filesGridColletionView.dataSource = self
        filesGridColletionView.delegate = self
    }
}

extension FilesGridView : NSCollectionViewDataSource {
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return filesListArray.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        if let cell = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "FilesGridItem"), for: indexPath) as? FilesGridItem {
            cell.configureCell(fileModel: filesListArray[indexPath.item])
            cell.fileLinkCallBack = { [weak self] str in
                guard let _self = self else { return }
                _self.url = str
            }
            return cell
        }
        return NSCollectionViewItem()
    }
}

extension FilesGridView : NSCollectionViewDelegate {
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        guard let indexPath = indexPaths.first else { return }
        print(indexPath)
    }
}
