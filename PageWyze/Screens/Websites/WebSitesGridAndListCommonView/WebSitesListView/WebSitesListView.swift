//
//  WebSitesListView.swift
//  WebSites
//
//  Created by PGK Shiva Kumar on 21/12/22.
//

import Cocoa

class WebSitesListView: NSView {
    
    @IBOutlet var parentCustomView: NSView!
    @IBOutlet weak var websiteListTableView: NSTableView!
    
    public var onItemClick: ((Int) -> Void)?
    public var websiteLogic: WebsitesLogic?
    
    init(websiteLogic: WebsitesLogic?) {
        self.websiteLogic = websiteLogic
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
        Bundle(for: WebSitesListView.self).loadNibNamed("WebSitesListView", owner: self, topLevelObjects: nil)
        let contentFrame = NSMakeRect(0, 0, frame.size.width, frame.size.height)
        parentCustomView.frame = contentFrame
        addSubview(parentCustomView)
    }
    
    public func commonMethods() {
        addView()
        configureTableView()
    }
    
    public func configureTableView() {
        websiteListTableView.dataSource = self
        websiteListTableView.delegate = self
    }
    
    public func reloadData() {
        websiteListTableView.reloadData()
    }
    
    public func reloadSelectedWebsite(index: Int) {
        websiteListTableView.reloadData(forRowIndexes: [index], columnIndexes: [0])
    }
    
    public func removeSelectedWebsite(index: Int) {
        websiteListTableView.removeRows(at: [index])
    }
    
    public func addWebsite() {
        websiteListTableView.beginUpdates()
        websiteListTableView.insertRows(at: [0])
        websiteListTableView.endUpdates()
    }
}

extension WebSitesListView : NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return websiteLogic?.sortedWebsiteList.count ?? 0
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = tableView.makeView(withIdentifier: tableColumn?.identifier ?? NSUserInterfaceItemIdentifier(rawValue: ""), owner: self) as? NSTableCellView
        cell?.textField?.font = .styleSelectionForSubtitle
        let website = websiteLogic?.sortedWebsiteList[row]
        switch tableColumn?.title {
        case "Name":
            cell?.textField?.stringValue = website?.name ?? ""
        case "Type":
            cell?.textField?.stringValue = website?.type ?? ""
        case "Url":
            cell?.textField?.stringValue = website?.url ?? ""
        case "Date":
            cell?.textField?.stringValue = website?.updated ?? ""
        case "Status":
            cell?.imageView?.setStatusImage(status: website?.datastatus ?? "")
        default:
            break
        }
        return cell
    }
}

extension WebSitesListView : NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 40
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        
        guard let selectedTableView = notification.object as? NSTableView else { return }
        if selectedTableView.selectedRow != -1 {
            onItemClick?(selectedTableView.selectedRow)
        }
        selectedTableView.deselectRow(selectedTableView.selectedRow)
    }
}
