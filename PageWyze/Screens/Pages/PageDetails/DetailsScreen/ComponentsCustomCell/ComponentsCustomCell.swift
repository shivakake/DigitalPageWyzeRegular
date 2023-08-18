//
//  ComponentsCustomCell.swift
//  WebSites
//
//  Created by Nagendar on 09/01/23.
//

import Cocoa

class ComponentsCustomCell: NSTableCellView {
    
    @IBOutlet weak var componentTitleLabel: NSTextField!
    @IBOutlet weak var componentTypeListCustomView: NSView!
    @IBOutlet weak var componentTypeTitleLabel: NSTextField!
    @IBOutlet weak var deleteComponentButton: NSButton!
    
    public var deleteComponentCallBack : ((String?)-> Void)?
    public var componentPopupItems: [PopUpMenuItemModel] = []
    public var componentModel: PageComponentDetailsModel? {
        didSet {
            configureCell()
        }
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        componentTypeListCustomView.setBorder(color: .lightGray)
        componentTypeTitleLabel.font = .styleSelectionForSubtitle
        
        componentTypeListCustomView.addGestureRecognizer(NSClickGestureRecognizer(target: self, action: #selector(componentTypeListViewTapped)))
    }
    
    func configureCell() {
        componentTitleLabel.stringValue = componentModel?.name ?? ""
        componentPopupItems.removeAll()
        for item in componentModel?.items ?? [] {
            componentPopupItems.append(PopUpMenuItemModel(strMenuID: item.type, menuName: item.name, menuImage: ""))
        }
        
        componentModel?.selectedName = componentModel?.items?.first?.name ?? "None"
        componentModel?.selectedId = componentModel?.items?.first?.id ?? "none"
        componentTypeTitleLabel.stringValue = componentModel?.selectedName ?? "None"
        
        deleteComponentButton.isHidden = componentModel?.name == "Stylesheet" || componentModel?.name == "Header" || componentModel?.name == "Footer" || componentModel?.name == "Head"
    }
    
    public func showPopUpForButtonViews() {
        let menu = PopUpMenuViewController(menuItems: componentPopupItems)
        menu.applyConstraintForCompleteMenu(tableSize: CGSize(width: 125, height: 60))
        menu.onSelectedItemModel = { [weak self] selectedTypeItem in
            guard let _self = self else { return }
            _self.componentTypeTitleLabel.stringValue = selectedTypeItem.itemName ?? ""
            _self.componentModel?.selectedId = selectedTypeItem.strID ?? "none"
            _self.componentModel?.selectedName = selectedTypeItem.itemName ?? "None"
        }
        self.window?.contentViewController?.present(menu, asPopoverRelativeTo: .zero, of: componentTypeTitleLabel, preferredEdge: .maxX, behavior: .transient)
    }
    
    
    @objc func componentTypeListViewTapped() {
        if !componentPopupItems.isEmpty {
            showPopUpForButtonViews()
        }
    }
    
    @IBAction func deleteComponentButtonTapped(_ sender: NSButton) {
        deleteComponentCallBack?(componentModel?.id)
    }
}
