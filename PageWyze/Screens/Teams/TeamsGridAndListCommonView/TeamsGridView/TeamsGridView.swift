//
//  TeamsGridView.swift
//  WebSites
//
//  Created by PGK Shiva Kumar on 31/12/22.
//

import Cocoa

class TeamsGridView: NSView {
    
    @IBOutlet var parentCustomView: NSView!
    @IBOutlet weak var teamsGridCollectionView: NSCollectionView!
    @IBOutlet weak var noDataField: NSTextField!
    
    public var teamLogic: TeamsLogic?
    public var onGridItemSelection: ((Int) -> Void)?
    
    init(teamLogic: TeamsLogic) {
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
        Bundle(for: TeamsGridView.self).loadNibNamed("TeamsGridView", owner: self, topLevelObjects: nil)
        let contentFrame = NSMakeRect(0, 0, frame.size.width, frame.size.height)
        parentCustomView.frame = contentFrame
        addSubview(parentCustomView)
    }
    
    public func configureColletionView() {
        teamsGridCollectionView.dataSource = self
        teamsGridCollectionView.delegate = self
    }
    
    public func reloadData() {
        noDataField.isHidden = teamLogic?.sortedTeamListArray.isEmpty == false
        teamsGridCollectionView.reloadData()
    }
    
    public func reloadSelectedTeamMember(index: Int) {
        teamsGridCollectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
    }
    
    public func removeSelectedTeamMember(index: Int) {
        teamsGridCollectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
        noDataField.isHidden = teamLogic?.sortedTeamListArray.isEmpty == false
    }
    
    public func addTeamMember() {
        noDataField.isHidden = true
        let indexPath = IndexPath(item: 0, section: 0)
        teamsGridCollectionView.insertItems(at: [indexPath])
    }
}

extension TeamsGridView : NSCollectionViewDataSource {
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return teamLogic?.sortedTeamListArray.count ?? 0
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        if let cell = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "TeamsGridItem"), for: indexPath) as? TeamsGridItem {
            cell.configureCell(teamModel: teamLogic?.sortedTeamListArray[indexPath.item])
            return cell
        }
        return NSCollectionViewItem()
    }
}

extension TeamsGridView : NSCollectionViewDelegate {
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        guard let indexPath = indexPaths.first?.item else { return }
        if indexPath != -1 {
            onGridItemSelection?(indexPath)
        }
        collectionView.deselectItems(at: indexPaths)
    }
}
