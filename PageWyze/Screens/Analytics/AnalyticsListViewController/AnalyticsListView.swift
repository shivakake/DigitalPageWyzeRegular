//
//  AnalyticsListView.swift
//  PageWyze
//
//  Created by PGK Shiva Kumar on 07/04/23.
//

import Cocoa

class AnalyticsListView: NSView {
    
    @IBOutlet var parentCustomView: NSView!
    @IBOutlet weak var userIntractionHandlerView: UIUserInteractionHandler!
    @IBOutlet weak var analyticsListTableView: NSTableView!
    
    public var websiteLogic: WebsitesLogic?
    public var analyticsLogic: AnalyticsLogic = AnalyticsLogic()
    public var analyticsDetails: AnalyticDetailsDataModel?
    public var activityIndicatorView = AlertMethodClass()
    
    init(websiteLogic: WebsitesLogic?) {
        self.websiteLogic = websiteLogic
        super.init(frame: .zero)
        commonMethodes()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonMethodes()
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    fileprivate func addView() {
        Bundle(for: AnalyticsListView.self).loadNibNamed("AnalyticsListView", owner: self, topLevelObjects: nil)
        parentCustomView.frame = NSMakeRect(0, 0, frame.size.width, frame.size.height)
        addSubview(parentCustomView)
    }
    
    public func commonMethodes() {
        addView()
        getList()
        configureTableView()
    }
    
    public func getList() {
        self.userIntractionHandlerView.isUserInteractionEnabled = false
        analyticsLogic.delegate = self
        activityIndicatorView.showLoader(view: self, showSpinner: true)
        analyticsLogic.getAnalyticsList(websiteId: websiteLogic?.websiteDetailsModel?.id)
    }
    
    fileprivate func configureTableView() {
        analyticsListTableView.dataSource = self
        analyticsListTableView.delegate = self
    }
}

extension AnalyticsListView : NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return analyticsLogic.analyticsListArray.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = tableView.makeView(withIdentifier: tableColumn?.identifier ?? NSUserInterfaceItemIdentifier(rawValue: ""), owner: self) as? NSTableCellView
        cell?.textField?.font = .styleSelectionForSubtitle
        switch tableColumn?.title {
        case "Name":
            cell?.textField?.stringValue = analyticsLogic.analyticsListArray[row].name ?? ""
        case "Url":
            cell?.textField?.stringValue = analyticsLogic.analyticsListArray[row].url ?? ""
        case "Views":
            cell?.textField?.stringValue = analyticsLogic.analyticsListArray[row].views ?? ""
        default:
            break
        }
        return cell
    }
}

extension AnalyticsListView : NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 40
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        guard let selectedTableView = notification.object as? NSTableView else { return }
        if selectedTableView.selectedRow != -1 {
            analyticsDetails = self.analyticsLogic.analyticsListArray[selectedTableView.selectedRow]
        }
        selectedTableView.deselectRow(selectedTableView.selectedRow)
    }
}

extension AnalyticsListView : AnalyticsLogicDelegate {
    
    func getAnalyticsListFromResponse() {
        DispatchQueue.main.async { [weak self] in
            guard let _self = self else { return }
            _self.activityIndicatorView.removeLoader()
            _self.userIntractionHandlerView.isUserInteractionEnabled = true
            _self.analyticsListTableView.reloadData()
        }
    }
    
    func showPoorInternet() { }
}
