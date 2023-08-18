//
//  ComponentListView.swift
//  WebSites
//
//  Created by PGK Shiva Kumar on 30/12/22.
//

import Cocoa

class ComponentListView: NSView {
    
    @IBOutlet var parentCustomView: NSView!
    @IBOutlet weak var componentListTableView: NSTableView!
    
    public var onListItemSelection: ((Int) -> Void)?
    public var componentLogic: ComponentsLogic?
    
    init(componentLogic: ComponentsLogic?) {
        self.componentLogic = componentLogic
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
        Bundle(for: ComponentListView.self).loadNibNamed("ComponentListView", owner: self, topLevelObjects: nil)
        let contentFrame = NSMakeRect(0, 0, frame.size.width, frame.size.height)
        parentCustomView.frame = contentFrame
        addSubview(parentCustomView)
    }
    
    public func commonMethods() {
        addView()
        configureTableView()
    }
    
    public func configureTableView() {
        componentListTableView.dataSource = self
        componentListTableView.delegate = self
    }
    
    public func reloadData() {
        componentListTableView.reloadData()
    }
    
    public func reloadSelectedComponent(index: Int) {
        componentListTableView.reloadData(forRowIndexes: [index], columnIndexes: [0])
    }
    
    public func removeSelectedComponent(index: Int) {
        componentListTableView.removeRows(at: [index])
    }
    
    public func addComponent() {
        componentListTableView.beginUpdates()
        componentListTableView.insertRows(at: [0])
        componentListTableView.endUpdates()
    }
}

extension ComponentListView : NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return componentLogic?.sortedComponentListArray.count ?? 0
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = tableView.makeView(withIdentifier: tableColumn?.identifier ?? NSUserInterfaceItemIdentifier(rawValue: ""), owner: self) as? NSTableCellView
        cell?.textField?.font = .styleSelectionForSubtitle
        switch tableColumn?.title {
        case "Name":
            cell?.textField?.stringValue = componentLogic?.sortedComponentListArray[row].name ?? ""
        case "Type":
            cell?.textField?.stringValue = componentLogic?.sortedComponentListArray[row].type ?? ""
        case "Date":
            cell?.textField?.stringValue = componentLogic?.sortedComponentListArray[row].updated ?? ""
        case "Status":
            cell?.imageView?.setStatusImage(status: componentLogic?.sortedComponentListArray[row].datastatus ?? "")
        default:
            break
        }
        return cell
    }
}

extension ComponentListView : NSTableViewDelegate {
    
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
