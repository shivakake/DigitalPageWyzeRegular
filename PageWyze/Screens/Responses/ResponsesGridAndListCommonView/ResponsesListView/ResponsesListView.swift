//
//  AnalyticsListView.swift
//  WebSites
//
//  Created by PGK Shiva Kumar on 04/01/23.
//

import Cocoa

class ResponsesListView: NSView {
    
    @IBOutlet var parentCustomView: NSView!
    @IBOutlet weak var responsesListTableView: NSTableView!
    
    var responsesListArray : [WebsiteDetailsDataModel] = [WebsiteDetailsDataModel]()
    let gridViewRef : ResponsesGridView = ResponsesGridView()
    var responsesDetailsCallBack: ((WebsiteDetailsDataModel) -> Void)?
    
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
        Bundle(for: ResponsesListView.self).loadNibNamed("ResponsesListView", owner: self, topLevelObjects: nil)
        let contentFrame = NSMakeRect(0, 0, frame.size.width, frame.size.height)
        parentCustomView.frame = contentFrame
        addSubview(parentCustomView)
    }
    
    public func commonMethods() {
        addView()
        configureTableView()
    }
    
    public func configureTableView() {
        responsesListTableView.dataSource = self
        responsesListTableView.delegate = self
        responsesListTableView.selectionHighlightStyle = .none
    }
}

extension ResponsesListView : NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return responsesListArray.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = tableView.makeView(withIdentifier: tableColumn?.identifier ?? NSUserInterfaceItemIdentifier(rawValue: ""), owner: self) as? NSTableCellView
        switch tableColumn?.title {
        case "Name":
            cell?.textField?.font = .styleSelectionForSubtitle
            cell?.textField?.stringValue = responsesListArray[row].name ?? ""
            return cell
        case "Type":
            cell?.textField?.font = .styleSelectionForSubtitle
            cell?.textField?.stringValue = responsesListArray[row].type ?? ""
            return cell
        case "Email":
            cell?.textField?.font = .styleSelectionForSubtitle
            cell?.textField?.stringValue = responsesListArray[row].name ?? ""
            return cell
        case "Mobile":
            cell?.textField?.font = .styleSelectionForSubtitle
            cell?.textField?.stringValue = responsesListArray[row].name ?? ""
            return cell
        case "Date":
            cell?.textField?.font = .styleSelectionForSubtitle
            cell?.textField?.stringValue = responsesListArray[row].updated ?? ""
            return cell
        case "Status":
            cell?.textField?.font = .styleSelectionForSubtitle
            cell?.imageView?.image = NSImage(named: responsesListArray[row].datastatus ?? "")
            return cell
        default:
            break
        }
        return NSView()
    }
}

extension ResponsesListView : NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 40
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        responsesDetailsCallBack?(responsesListArray[responsesListTableView.selectedRow])
    }
}
