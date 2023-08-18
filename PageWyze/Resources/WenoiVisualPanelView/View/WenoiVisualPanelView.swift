//
//  WenoiVisualPanelView.swift
//  WenoiUI
//
//  Created by Roushil singla on 9/29/20.
//  Copyright © 2020 personal. All rights reserved.
//

import Cocoa

// MARK:- Ask for status image in  collectionview

public class WenoiVisualPanelView: NSView {
    
    /* Outlets */
    @IBOutlet var customView: NSView!
    @IBOutlet weak var visualCollectionView: NSCollectionView!
    @IBOutlet weak var searchBar: NSSearchField!
    
    lazy var hideStatusImage = true
    lazy var visualPanelModel: [WenoiVisualPanelModel] = []
    lazy var searchedValue = [WenoiVisualPanelModel]()
    lazy var defaultImage = NSImage()
    var isSearching = false
    public var fetchedCountryOrLanguage: ((String?, String?)-> Void)?
    
    public override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        setUpBorders()
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        addView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addView()
    }
    
    /* Loading views */
    private func addView() {
        
        Bundle(for: WenoiVisualPanelView.self).loadNibNamed("WenoiVisualPanelView", owner: self, topLevelObjects: nil)
        let contentFrame = NSMakeRect(0, 0, frame.size.width, frame.size.height)
        customView.frame = contentFrame
        addSubview(customView)
    }
    
    @IBAction func searchFieldSelected(_ sender: NSSearchField) {
        /* Action when User starts Searching and filtering the table based on entered Value */
        searchedValue = visualPanelModel.filter{($0.strTitle?.contains(sender.stringValue) ?? false)}
        sender.stringValue.isEmpty ? (isSearching = false) : (isSearching = true)
        DispatchQueue.main.async {
            self.visualCollectionView.reloadData()
        }
    }
    
    /* Add borders To Panel View */
    private func setUpBorders() {
        customView.wantsLayer           = true
        customView.layer?.borderColor   = StyleSheet.appColor.cgColor
        customView.layer?.borderWidth   = 1.0
        customView.layer?.cornerRadius  = 8
    }
    
    /* Setup CollectionView with Model or Default values */
    public func setUpCollectionView(with model: [WenoiVisualPanelModel]?, defaultImage: NSImage, hideStatus: Bool, hideSearchBar: Bool) {
        guard let visualModel = model else { return }
        visualPanelModel                = visualModel
        self.defaultImage               = defaultImage
        hideStatusImage                 = hideStatus
        searchBar.isHidden              = hideSearchBar
        visualCollectionView.dataSource = self
        visualCollectionView.delegate   = self
    }
    
    fileprivate func deSelectAllSelectedModel() {
        visualCollectionView.visibleItems().forEach { cell in
            guard let dotCell = cell as? VisualPanelCell else { return }
            dotCell.isPanelSelected = false
        }
        isSearching ?
            searchedValue.indices.forEach({ searchedValue[$0].blIsSelected = false }) :
            visualPanelModel.indices.forEach({ visualPanelModel[$0].blIsSelected = false })
    }
    
}

extension WenoiVisualPanelView: NSCollectionViewDataSource, NSCollectionViewDelegate {
    
    /* Number of Items in Collection */
    public func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return isSearching ? (searchedValue.count) : (visualPanelModel.count)
    }
    
    /* Setting Items in Collection and filtering items based on searched value */
    public func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
    
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "VisualPanelCell"), for: indexPath)
        guard let panelItem = item as? VisualPanelCell else { return item }
        panelItem.hideStatus = hideStatusImage
        
        
        
        if isSearching {
            let model = searchedValue[indexPath.item]
            var image = NSImage()
            if (model.strImage ?? "").isEmpty || model.strImage == nil {
                image = defaultImage
            } else {
                image = NSImage(named: model.strImage!) ?? defaultImage
            }
            (panelItem.panelModel = (model, image))
            panelItem.isPanelSelected = model.blIsSelected ?? false
            
        } else {
            let model = visualPanelModel[indexPath.item]
            var image = NSImage()
            if (model.strImage ?? "").isEmpty || model.strImage == nil {
                image = defaultImage
            } else {
                image = NSImage(named: model.strImage!) ?? defaultImage
            }
            
            (panelItem.panelModel = (model, image))
            panelItem.isPanelSelected = model.blIsSelected ?? false
        }
        
        panelItem.onPanelTapped = { [weak self] in
            guard let _self = self else { return }
            
            _self.deSelectAllSelectedModel()
            if _self.isSearching {
                _self.searchedValue[indexPath.item].blIsSelected = true
                _self.fetchedCountryOrLanguage?(_self.searchedValue[indexPath.item].strId ,panelItem.titleName.stringValue)
            } else {
                _self.visualPanelModel[indexPath.item].blIsSelected = true
                _self.fetchedCountryOrLanguage?(_self.visualPanelModel[indexPath.item].strId ,panelItem.titleName.stringValue)
            }
            panelItem.isPanelSelected = true
        }
        
        return panelItem
    }
}
