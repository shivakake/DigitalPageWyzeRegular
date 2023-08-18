//
//  PagesListView.swift
//  WebSites
//
//  Created by PGK Shiva Kumar on 30/12/22.
//

import Cocoa

class PagesListView: NSView {
    
    @IBOutlet var parentCustomView: NSView!
    @IBOutlet weak var pagesListTableView: NSTableView!
    
    public var onListItemSelection: ((Int) -> Void)?
    public var pageLogic: PagesLogic?
    
    init(pageLogic: PagesLogic?) {
        self.pageLogic = pageLogic
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
        Bundle(for: PagesListView.self).loadNibNamed("PagesListView", owner: self, topLevelObjects: nil)
        let contentFrame = NSMakeRect(0, 0, frame.size.width, frame.size.height)
        parentCustomView.frame = contentFrame
        addSubview(parentCustomView)
    }
    
    public func commonMethods() {
        addView()
        configureTableView()
    }
    
    public func configureTableView() {
        pagesListTableView.dataSource = self
        pagesListTableView.delegate = self
        
        pagesListTableView.register(NSNib(nibNamed: "DetailsPageButtonCell", bundle: Bundle(for: DetailsPageButtonCell.self)), forIdentifier: NSUserInterfaceItemIdentifier(rawValue: "DetailsPageButtonCell"))
        
        pagesListTableView.register(NSNib(nibNamed: "UrlPageButtonCell", bundle: Bundle(for: UrlPageButtonCell.self)), forIdentifier: NSUserInterfaceItemIdentifier(rawValue: "UrlPageButtonCell"))
    }
    
    public func reloadData() {
        pagesListTableView.reloadData()
    }
    
    public func reloadSelectedPage(index: Int) {
        pagesListTableView.reloadData(forRowIndexes: [index], columnIndexes: [0])
    }
    
    public func removeSelectedPage(index: Int) {
        pagesListTableView.removeRows(at: [index])
    }
    
    public func addPage() {
        pagesListTableView.beginUpdates()
        pagesListTableView.insertRows(at: [0])
        pagesListTableView.endUpdates()
    }
}

extension PagesListView : NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return pageLogic?.sortedPageListArray.count ?? 0
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        switch tableColumn?.title {
        case "":
            guard let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "DetailsPageButtonCell"), owner: self) as? DetailsPageButtonCell else { return NSView() }
            cell.detailsCallBack = { [weak self] in
                guard let _self = self else { return }
                let controller = AddAndEditPageView(pageLogic: nil, pageDelegate: nil, websiteLogic: nil, editComingFrom: "")
                _self.addViewThroughConstraints(for: controller, in: _self.parentCustomView ?? NSView())
            }
            return cell
        case "Name":
            let cell = tableView.makeView(withIdentifier: tableColumn?.identifier ?? NSUserInterfaceItemIdentifier(rawValue: ""), owner: self) as? NSTableCellView
            cell?.textField?.font = .styleSelectionForSubtitle
            cell?.textField?.stringValue = pageLogic?.sortedPageListArray[row].name ?? ""
            return cell
        case "Url":
            guard let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "UrlPageButtonCell"), owner: self) as? UrlPageButtonCell else { return NSView()}
            cell.textField?.font = .styleSelectionForSubtitle
            cell.urlLabel.stringValue = pageLogic?.sortedPageListArray[row].url ?? ""
            cell.urlCallBack = { [weak self] urlString in
                guard let _self = self else { return }
                let controller = AddAndEditPageView(pageLogic: nil, pageDelegate: nil, websiteLogic: nil, editComingFrom: "")
                _self.addViewThroughConstraints(for: controller, in: _self.parentCustomView ?? NSView())
            }
            return cell
        case "Description":
            let cell = tableView.makeView(withIdentifier: tableColumn?.identifier ?? NSUserInterfaceItemIdentifier(rawValue: ""), owner: self) as? NSTableCellView
            cell?.textField?.font = .styleSelectionForSubtitle
            cell?.textField?.stringValue = pageLogic?.sortedPageListArray[row].description ?? ""
            return cell
        case "Meta Title":
            let cell = tableView.makeView(withIdentifier: tableColumn?.identifier ?? NSUserInterfaceItemIdentifier(rawValue: ""), owner: self) as? NSTableCellView
            cell?.textField?.font = .styleSelectionForSubtitle
            cell?.textField?.stringValue = pageLogic?.sortedPageListArray[row].metatitle ?? ""
            return cell
        case "Meta Description":
            let cell = tableView.makeView(withIdentifier: tableColumn?.identifier ?? NSUserInterfaceItemIdentifier(rawValue: ""), owner: self) as? NSTableCellView
            cell?.textField?.font = .styleSelectionForSubtitle
            cell?.textField?.stringValue = pageLogic?.sortedPageListArray[row].metadescription ?? ""
            return cell
        default:
            break
        }
        return NSView()
    }
}

extension PagesListView : NSTableViewDelegate {
    
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
