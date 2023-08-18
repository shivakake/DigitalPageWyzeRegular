//
//  TeamsListView.swift
//  WebSites
//
//  Created by PGK Shiva Kumar on 30/12/22.
//

import Cocoa

class TeamsListView: NSView {
    
    @IBOutlet var parentCustomView: NSView!
    @IBOutlet weak var teamsListTableView: NSTableView!
    
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
        Bundle(for: TeamsListView.self).loadNibNamed("TeamsListView", owner: self, topLevelObjects: nil)
        let contentFrame = NSMakeRect(0, 0, frame.size.width, frame.size.height)
        parentCustomView.frame = contentFrame
        addSubview(parentCustomView)
    }
    
    public func commonMethods() {
        addView()
        configureTableView()
    }
    
    public func configureTableView() {
        teamsListTableView.dataSource = self
        teamsListTableView.delegate = self
    }
    
    public func reloadData() {
        teamsListTableView.reloadData()
    }
    
    public func reloadSelectedTeamMember(index: Int) {
        teamsListTableView.reloadData(forRowIndexes: [index], columnIndexes: [0])
    }
    
    public func removeSelectedTeamMember(index: Int) {
        teamsListTableView.removeRows(at: [index])
    }
    
    public func addTeamMember() {
        teamsListTableView.beginUpdates()
        teamsListTableView.insertRows(at: [0])
        teamsListTableView.endUpdates()
    }
}

extension TeamsListView : NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return teamLogic?.sortedTeamListArray.count ?? 0
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = tableView.makeView(withIdentifier: tableColumn?.identifier ?? NSUserInterfaceItemIdentifier(rawValue: ""), owner: self) as? NSTableCellView
        
        cell?.textField?.font = .styleSelectionForSubtitle
        
        switch tableColumn?.title {
        
        case "Name":
            cell?.textField?.stringValue = teamLogic?.sortedTeamListArray[row].name ?? ""
        case "Title":
            cell?.textField?.stringValue = teamLogic?.sortedTeamListArray[row].title ?? ""
        case "Role":
            cell?.textField?.stringValue = teamLogic?.sortedTeamListArray[row].rolename ?? ""
        case "Status":
            cell?.imageView?.setStatusImage(status: teamLogic?.sortedTeamListArray[row].datastatus)
        default:
            break
        }
        return cell
    }
}

extension TeamsListView : NSTableViewDelegate {
    
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
