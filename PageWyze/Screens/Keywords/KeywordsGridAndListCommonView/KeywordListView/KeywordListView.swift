//
//  KeywordListView.swift
//  WebSites
//
//  Created by PGK Shiva Kumar on 04/01/23.
//

import Cocoa

class KeywordListView: NSView {
    
    @IBOutlet var parentCustomView: NSView!
    @IBOutlet weak var keywordListTableView: NSTableView!
    
    public var onListItemSelection: ((Int) -> Void)?
    public var keywordLogic: KeywordLogic?
    
    init(keywordLogic: KeywordLogic?) {
        self.keywordLogic = keywordLogic
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
        Bundle(for: KeywordListView.self).loadNibNamed("KeywordListView", owner: self, topLevelObjects: nil)
        let contentFrame = NSMakeRect(0, 0, frame.size.width, frame.size.height)
        parentCustomView.frame = contentFrame
        addSubview(parentCustomView)
    }
    
    public func commonMethods() {
        addView()
        configureTableView()
    }
    
    public func configureTableView() {
        keywordListTableView.dataSource = self
        keywordListTableView.delegate = self
    }
    
    public func reloadData() {
        keywordListTableView.reloadData()
    }
    
    public func reloadSelectedKeyword(index: Int) {
        keywordListTableView.reloadData(forRowIndexes: [index], columnIndexes: [0])
    }
    
    public func removeSelectedKeyword(index: Int) {
        keywordListTableView.removeRows(at: [index])
    }
    
    public func addKeyword() {
        keywordListTableView.beginUpdates()
        keywordListTableView.insertRows(at: [0])
        keywordListTableView.endUpdates()
    }
}

extension KeywordListView : NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return keywordLogic?.sortedKeywordListArray.count ?? 0
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = tableView.makeView(withIdentifier: tableColumn?.identifier ?? NSUserInterfaceItemIdentifier(rawValue: ""), owner: self) as? NSTableCellView
        cell?.textField?.font = .styleSelectionForSubtitle
        switch tableColumn?.title {
        case "Name":
            cell?.textField?.stringValue = keywordLogic?.sortedKeywordListArray[row].name ?? ""
        case "Date":
            cell?.textField?.stringValue = keywordLogic?.sortedKeywordListArray[row].updated ?? ""
        case "Status":
            cell?.imageView?.setStatusImage(status: keywordLogic?.sortedKeywordListArray[row].datastatus)
        default:
            break
        }
        return cell
    }
}

extension KeywordListView : NSTableViewDelegate {
    
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
