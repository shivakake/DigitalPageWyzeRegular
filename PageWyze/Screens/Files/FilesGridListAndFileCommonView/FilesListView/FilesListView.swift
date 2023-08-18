//
//  FilesListView.swift
//  WebSites
//
//  Created by PGK Shiva Kumar on 04/01/23.
//

import Cocoa

class FilesListView: NSView {
    
    @IBOutlet var parentCustomView: NSView!
    @IBOutlet weak var filesListTableView: NSTableView!
    
    var filesListAray : [WebsiteDetailsDataModel] = [WebsiteDetailsDataModel]()
    let gridViewRef : FilesGridView = FilesGridView()
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
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
        Bundle(for: FilesListView.self).loadNibNamed("FilesListView", owner: self, topLevelObjects: nil)
        let contentFrame = NSMakeRect(0, 0, frame.size.width, frame.size.height)
        parentCustomView.frame = contentFrame
        addSubview(parentCustomView)
    }
    
    public func commonMethods() {
        addView()
        getList()
        configureTableView()
    }
    
    public func configureTableView() {
        filesListTableView.dataSource = self
        filesListTableView.delegate = self
    }
    
    public func getList() {
        gridViewRef.getFilesList()
        filesListAray = gridViewRef.filesListArray
    }
}

extension FilesListView : NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return filesListAray.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = tableView.makeView(withIdentifier: tableColumn?.identifier ?? NSUserInterfaceItemIdentifier(rawValue: ""), owner: self) as? NSTableCellView
        cell?.textField?.font = .styleSelectionForSubtitle
        switch tableColumn?.title {
        case "Name":
            cell?.textField?.stringValue = filesListAray[row].name ?? ""
        case "Type":
            cell?.textField?.stringValue = filesListAray[row].type ?? ""
        case "Date":
            cell?.textField?.stringValue = filesListAray[row].updated ?? ""
        case "Status":
            cell?.imageView?.image = NSImage(named: filesListAray[row].datastatus ?? "")
        default:
            break
        }
        return cell
    }
}

extension FilesListView : NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 40
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        let model = filesListAray[filesListTableView.selectedRow]
        print(model)
    }
}
