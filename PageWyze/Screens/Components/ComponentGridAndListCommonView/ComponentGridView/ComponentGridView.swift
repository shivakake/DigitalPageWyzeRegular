//
//  ComponentGridView.swift
//  WebSites
//
//  Created by PGK Shiva Kumar on 30/12/22.
//

import Cocoa

class ComponentGridView: NSView {
    
    @IBOutlet var parentCustomView: NSView!
    @IBOutlet weak var componentGridCollectionView: NSCollectionView!
    @IBOutlet weak var noDataField: NSTextField!
    
    public var componentLogic: ComponentsLogic?
    public var onGridItemSelection: ((Int) -> Void)?
    
    init(componentLogic: ComponentsLogic) {
        super.init(frame: .zero)
        self.componentLogic = componentLogic
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
        Bundle(for: ComponentGridView.self).loadNibNamed("ComponentGridView", owner: self, topLevelObjects: nil)
        let contentFrame = NSMakeRect(0, 0, frame.size.width, frame.size.height)
        parentCustomView.frame = contentFrame
        addSubview(parentCustomView)
    }
    
    public func configureColletionView() {
        componentGridCollectionView.dataSource = self
        componentGridCollectionView.delegate = self
    }
    
    public func reloadData() {
        noDataField.isHidden = componentLogic?.sortedComponentListArray.isEmpty == false
        componentGridCollectionView.reloadData()
    }
    
    public func reloadSelectedComponent(index: Int) {
        componentGridCollectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
    }
    
    public func removeSelectedComponent(index: Int) {
        componentGridCollectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
        noDataField.isHidden = componentLogic?.sortedComponentListArray.isEmpty == false
    }
    
    public func addComponent() {
        noDataField.isHidden = true
        let indexPath = IndexPath(item: 0, section: 0)
        componentGridCollectionView.insertItems(at: [indexPath])
    }
}

extension ComponentGridView : NSCollectionViewDataSource {
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return componentLogic?.sortedComponentListArray.count ?? 0
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        if let cell = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ComponentGridItem"), for: indexPath) as? ComponentGridItem {
            cell.configureCell(componentModel: componentLogic?.sortedComponentListArray[indexPath.item])
            return cell
        }
        return NSCollectionViewItem()
    }
}

extension ComponentGridView : NSCollectionViewDelegate {
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        guard let indexPath = indexPaths.first?.item else { return }
        if indexPath != -1 {
            onGridItemSelection?(indexPath)
        }
        collectionView.deselectItems(at: indexPaths)
    }
}
