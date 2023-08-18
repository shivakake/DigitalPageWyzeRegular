//
//  RolesListView.swift
//  WebSites
//
//  Created by PGK Shiva Kumar on 31/12/22.
//

import Cocoa

class RolesListView: NSView {
    
    @IBOutlet var parentCustomView: NSView!
    @IBOutlet weak var rolesListTableView: NSTableView!
    
    public var onListItemSelection: ((Int) -> Void)?
    public var teamLogic: TeamsLogic?
    
    init(teamLogic: TeamsLogic?) {
        self.teamLogic = teamLogic
        super.init(frame: .zero)
        commonMethods()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonMethods()
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    fileprivate func addView() {
        Bundle(for: RolesListView.self).loadNibNamed("RolesListView", owner: self, topLevelObjects: nil)
        let contentFrame = NSMakeRect(0, 0, frame.size.width, frame.size.height)
        parentCustomView.frame = contentFrame
        addSubview(parentCustomView)
    }
    
    public func commonMethods() {
        addView()
        configureTableView()
    }
    
    public func configureTableView() {
        rolesListTableView.dataSource = self
        rolesListTableView.delegate = self
    }
    
    public func reloadData() {
        rolesListTableView.reloadData()
    }
    
    public func reloadSelectedRole(index: Int) {
        rolesListTableView.reloadData(forRowIndexes: [index], columnIndexes: [0])
    }
    
    public func removeSelectedRole(index: Int) {
        rolesListTableView.removeRows(at: [index])
    }
    
    public func addRole() {
        rolesListTableView.beginUpdates()
        rolesListTableView.insertRows(at: [0])
        rolesListTableView.endUpdates()
    }
}

extension RolesListView : NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return teamLogic?.rolesListArray.count ?? 0
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = tableView.makeView(withIdentifier: tableColumn?.identifier ?? NSUserInterfaceItemIdentifier(rawValue: ""), owner: self) as? NSTableCellView
        cell?.textField?.font = .styleSelectionForSubtitle
        switch tableColumn?.title {
        case "Name":
            cell?.textField?.stringValue = teamLogic?.rolesListArray[row].name ?? ""
        case "Date":
            cell?.textField?.stringValue = teamLogic?.rolesListArray[row].description ?? ""
        case "Status":
            cell?.imageView?.setStatusImage(status: teamLogic?.rolesListArray[row].datastatus ?? "live")
            break
        default:
            break
        }
        return cell
    }
}

extension RolesListView : NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 40
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        guard let selectedTableView = notification.object as? NSTableView else { return }
        if selectedTableView.selectedRow != -1 {
            onListItemSelection?(selectedTableView.selectedRow)
        }
        selectedTableView.deselectRow(selectedTableView.selectedRow)
    }
}
