//
//  FilesFileView.swift
//  WebSites
//
//  Created by PGK Shiva Kumar on 04/01/23.
//

import Cocoa

class FilesFileView: NSView {
    
    @IBOutlet var parentCustomView: NSView!
    @IBOutlet weak var filesFileColletionView: NSCollectionView!
    
    var filesListArray : [WebsiteDetailsDataModel] = [WebsiteDetailsDataModel]()
    let gridViewRef : FilesGridView = FilesGridView()
    
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
        Bundle(for: FilesFileView.self).loadNibNamed("FilesFileView", owner: self, topLevelObjects: nil)
        let contentFrame = NSMakeRect(0, 0, frame.size.width, frame.size.height)
        parentCustomView.frame = contentFrame
        addSubview(parentCustomView)
    }
    
    public func configureColletionView() {
        filesFileColletionView.dataSource = self
        filesFileColletionView.delegate = self
    }
    
    public func getFilesList() {
        gridViewRef.getFilesList()
        filesListArray = gridViewRef.filesListArray
    }
}

extension FilesFileView : NSCollectionViewDataSource {
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return filesListArray.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        if let cell = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "FilesFileItem"), for: indexPath) as? FilesFileItem {
            cell.configureCell(fileModel: filesListArray[indexPath.item])
            return cell
        }
        return NSCollectionViewItem()
    }
}

extension FilesFileView : NSCollectionViewDelegate {
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        guard let indexPath = indexPaths.first else { return }
        print(indexPath)
    }
}
