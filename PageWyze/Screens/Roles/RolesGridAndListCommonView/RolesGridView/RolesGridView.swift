//
//  RolesGridView.swift
//  WebSites
//
//  Created by PGK Shiva Kumar on 31/12/22.
//

import Cocoa

class RolesGridView: NSView {
    
    @IBOutlet var parentCustomView: NSView!
    @IBOutlet weak var roleGridCollectionView: NSCollectionView!
    @IBOutlet weak var noDataField: NSTextField!
    
    public var teamLogic: TeamsLogic?
    public var onGridItemSelection: ((Int) -> Void)?
    
    init(teamLogic: TeamsLogic?) {
        super.init(frame: .zero)
        self.teamLogic = teamLogic
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
        Bundle(for: RolesGridView.self).loadNibNamed("RolesGridView", owner: self, topLevelObjects: nil)
        let contentFrame = NSMakeRect(0, 0, frame.size.width, frame.size.height)
        parentCustomView.frame = contentFrame
        addSubview(parentCustomView)
    }
    
    public func configureColletionView() {
        roleGridCollectionView.dataSource = self
        roleGridCollectionView.delegate = self
    }
    
    public func reloadData() {
        noDataField.isHidden = teamLogic?.rolesListArray.isEmpty == false
        roleGridCollectionView.reloadData()
    }
    
    public func reloadSelectedRole(index: Int) {
        roleGridCollectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
    }
    
    public func removeSelectedRole(index: Int) {
        roleGridCollectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
        noDataField.isHidden = teamLogic?.rolesListArray.isEmpty == false
    }
    
    public func addRole() {
        noDataField.isHidden = true
        let indexPath = IndexPath(item: 0, section: 0)
        roleGridCollectionView.insertItems(at: [indexPath])
    }
}

extension RolesGridView : NSCollectionViewDataSource {
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return teamLogic?.rolesListArray.count ?? 0
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        if let cell = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "RoleGridItem"), for: indexPath) as? RoleGridItem {
            cell.configureCell(roleModel: teamLogic?.rolesListArray[indexPath.item])
            return cell
        }
        return NSCollectionViewItem()
    }
}

extension RolesGridView : NSCollectionViewDelegate {
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        guard let indexPath = indexPaths.first?.item else { return }
        if indexPath != -1 {
            onGridItemSelection?(indexPath)
        }
        collectionView.deselectItems(at: indexPaths)
    }
}
